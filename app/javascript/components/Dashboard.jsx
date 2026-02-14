import React, { useEffect, useState } from "react";
import { csrfToken } from "../lib/csrf";

export default function Dashboard({ nutritionistId }) {
  const [pendingAppointments, setPendingAppointments] = useState([]);
  const [scheduledAppointments, setScheduledAppointments] = useState([]);

  useEffect(() => {
    fetchAppointments();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  function fetchAppointments() {
    // Fetch pending appointments
    fetch(`/api/appointments?nutritionist_id=${nutritionistId}&status=pending`)
      .then((r) => r.json())
      .then((data) => setPendingAppointments(data || []));

    // Fetch accepted/scheduled appointments
    fetch(`/api/appointments?nutritionist_id=${nutritionistId}&status=accepted`)
      .then((r) => r.json())
      .then((data) => setScheduledAppointments(data || []));
  }

  function patchAction(id, action) {
    fetch(`/api/appointments/${id}/${action}`, {
      method: "PATCH",
      headers: { "X-CSRF-Token": csrfToken() },
    })
      .then((r) => r.json())
      .then(() => fetchAppointments());
  }

  return (
    <div>
      <h2>Pending Appointment Requests</h3>
      {pendingAppointments.length === 0 && <div>No pending requests.</div>}
      {pendingAppointments.map((a) => (
        <div key={a.id} style={{ border: "1px solid #ffc107", padding: 10, marginBottom: 8, backgroundColor: "#fff8e1" }}>
          <div><strong>{a.guest_name}</strong> — {a.guest_email}</div>
          <div>Requested: {new Date(a.start_time).toLocaleString()}</div>
          <div>Service: {a.service.name} ({a.service.location})</div>
          <div style={{ marginTop: 8 }}>
            <button onClick={() => patchAction(a.id, 'accept')} style={{ marginRight: 8 }}>Accept</button>
            <button onClick={() => patchAction(a.id, 'reject')}>Reject</button>
          </div>
        </div>
      ))}

      <h3 style={{ marginTop: 24 }}>Scheduled Appointments</h3>
      {scheduledAppointments.length === 0 && <div>No scheduled appointments.</div>}
      {scheduledAppointments.map((a) => (
        <div key={a.id} style={{ border: "1px solid #4caf50", padding: 10, marginBottom: 8, backgroundColor: "#f1f8e9" }}>
          <div><strong>{a.guest_name}</strong> — {a.guest_email}</div>
          <div>Scheduled for: {new Date(a.start_time).toLocaleString()}</div>
          <div>Service: {a.service.name} ({a.service.location})</div>
          <div style={{ marginTop: 8, color: "#4caf50", fontWeight: "bold" }}>✓ Confirmed</div>
        </div>
      ))}
    </div>
  );
}
