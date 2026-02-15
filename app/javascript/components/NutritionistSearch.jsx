import React, { useState, useEffect } from "react";
import Modal from "./ui/Modal";
import { csrfToken } from "../lib/csrf";

export default function NutritionistSearch() {
  const [q, setQ] = useState("");
  const [location, setLocation] = useState("");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);

  const [modalOpen, setModalOpen] = useState(false);
  const [selectedService, setSelectedService] = useState(null);
  const [guestName, setGuestName] = useState("");
  const [guestEmail, setGuestEmail] = useState("");
  const [startTime, setStartTime] = useState("");

  useEffect(() => {
    // initial load with default location (server falls back to Braga)
    fetchResults();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  function fetchResults() {
    setLoading(true);
    const params = new URLSearchParams();
    if (q) params.set("q", q);
    if (location) params.set("location", location);

    fetch(`/nutritionists.json?${params.toString()}`)
      .then((r) => r.json())
      .then((data) => setResults(data || []))
      .finally(() => setLoading(false));
  }

  function openSchedule(service) {
    setSelectedService(service);
    setModalOpen(true);
  }

  function submitAppointment(e) {
    e.preventDefault();
    if (!selectedService) return;

    fetch("/appointments", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken(),
      },
      body: JSON.stringify({ appointment: { guest_name: guestName, guest_email: guestEmail, start_time: startTime, service_id: selectedService.id } }),
    })
      .then((r) => {
        if (!r.ok) throw r;
        return r.json();
      })
      .then(() => {
        alert("Appointment scheduled — we'll email confirmation shortly.");
        setModalOpen(false);
        setGuestName("");
        setGuestEmail("");
        setStartTime("");
      })
      .catch(async (err) => {
        try {
          const body = await err.json();
          alert("Failed: " + (body.errors || []).join(", "));
        } catch (_) {
          alert("Failed to schedule appointment");
        }
      });
  }

  return (
    <div className="max-w-3xl mx-auto p-4">
      {/* Header and Search Card */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden mb-8">
        <div className="bg-green-100 p-6">
          <h1 className="text-3xl font-bold text-green-800">Nutribook</h1>
        </div>
        <div className="bg-green-50 p-6 flex gap-4 items-center">
          <input
            className="flex-1 p-2 border border-green-200 rounded focus:outline-none focus:ring-2 focus:ring-green-400"
            placeholder="Name or service"
            value={q}
            onChange={(e) => setQ(e.target.value)}
          />
          <input
            className="flex-1 p-2 border border-green-200 rounded focus:outline-none focus:ring-2 focus:ring-green-400"
            placeholder="Location (city or lat,lon)"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
          />
          <button
            onClick={fetchResults}
            className="bg-orange-200 hover:bg-orange-300 text-orange-900 font-medium py-2 px-6 rounded transition-colors"
          >
            Search
          </button>
        </div>
      </div>

      {loading ? (
        <div className="text-center text-gray-500 py-8">Loading…</div>
      ) : (
        <div className="space-y-4">
          {results.length === 0 && (
            <div className="text-center text-gray-500 py-8">No nutritionists found.</div>
          )}
          {results.map((r) => (
            <div
              key={r.id}
              className="bg-white rounded-lg shadow-sm p-6 border border-gray-100 flex justify-between items-start"
            >
              <div>
                <strong className="text-xl text-gray-800 block mb-1">{r.name}</strong>
                <div className="text-gray-600 text-sm mb-1">
                  {r.service.name} — {r.service.location}
                </div>
                <div className="text-gray-500 text-xs">Distance: {r.distance_km} km</div>
              </div>
              <div className="flex flex-col gap-3">
                <button
                  onClick={() => openSchedule(r.service)}
                  className="bg-red-100 hover:bg-red-200 text-red-900 py-2 px-4 rounded text-sm font-medium transition-colors"
                >
                  Schedule Appointment
                </button>
                <button
                  onClick={() => alert("Website placeholder")}
                  className="bg-green-100 hover:bg-green-200 text-green-900 py-2 px-4 rounded text-sm font-medium transition-colors"
                >
                  Website
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      <Modal open={modalOpen} onClose={() => setModalOpen(false)}>
        <h3>Schedule appointment</h3>
        <form onSubmit={submitAppointment}>
          <div>
            <label>Name</label>
            <input required value={guestName} onChange={(e) => setGuestName(e.target.value)} />
          </div>
          <div>
            <label>Email</label>
            <input required type="email" value={guestEmail} onChange={(e) => setGuestEmail(e.target.value)} />
          </div>
          <div>
            <label>Date & time</label>
            <input required type="datetime-local" value={startTime} onChange={(e) => setStartTime(e.target.value)} />
          </div>
          <div style={{ marginTop: 10 }}>
            <button type="submit">Book</button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
