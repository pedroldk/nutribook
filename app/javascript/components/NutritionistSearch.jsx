import React, { useState, useEffect } from "react";

function csrfToken() {
  const el = document.querySelector('meta[name="csrf-token"]');
  return el ? el.content : "";
}

function Modal({ open, onClose, children }) {
  if (!open) return null;
  return (
    <div style={{ position: "fixed", left: 0, top: 0, right: 0, bottom: 0, background: "rgba(0,0,0,0.4)", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <div style={{ background: "white", padding: 20, borderRadius: 6, minWidth: 300 }}>
        {children}
        <div style={{ marginTop: 12, textAlign: "right" }}>
          <button onClick={onClose}>Close</button>
        </div>
      </div>
    </div>
  );
}

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
    <div>
      <h2>Find a Nutritionist</h2>
      <div style={{ display: "flex", gap: 8, marginBottom: 12 }}>
        <input placeholder="Name or service" value={q} onChange={(e) => setQ(e.target.value)} />
        <input placeholder="Location (city or lat,lon)" value={location} onChange={(e) => setLocation(e.target.value)} />
        <button onClick={fetchResults}>Search</button>
      </div>

      {loading ? (
        <div>Loading…</div>
      ) : (
        <div>
          {results.length === 0 && <div>No nutritionists found.</div>}
          {results.map((r) => (
            <div key={r.id} style={{ border: "1px solid #eee", padding: 12, marginBottom: 8 }}>
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <div>
                  <strong>{r.name}</strong>
                  <div style={{ fontSize: 12 }}>{r.service.name} — {r.service.location}</div>
                  <div style={{ fontSize: 12 }}>Distance: {r.distance_km} km</div>
                </div>
                <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                  <button onClick={() => openSchedule(r.service)}>Schedule Appointment</button>
                  <button onClick={() => alert('Personal Page placeholder')}>Personal Page</button>
                </div>
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
