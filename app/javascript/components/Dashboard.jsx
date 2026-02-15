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
    <div className="space-y-8">
      {/* Pending Appointment Requests */}
      <div>
        <h3 className="text-xl font-semibold text-gray-800 mb-4">
          Pending Appointment Requests
        </h3>
        {pendingAppointments.length === 0 && (
          <div className="text-center text-gray-500 py-8">
            No pending requests.
          </div>
        )}
        <div className="space-y-4">
          {pendingAppointments.map((a) => (
            <div
              key={a.id}
              className="bg-white rounded-lg shadow-sm p-6 border border-orange-200 flex justify-between items-start"
            >
              <div>
                <strong className="text-lg text-gray-800 block mb-1">
                  {a.guest_name}
                </strong>
                <div className="text-gray-600 text-sm mb-1">
                  {a.guest_email}
                </div>
                <div className="text-gray-500 text-xs">
                  Requested: {new Date(a.start_time).toLocaleString()}
                </div>
                <div className="text-gray-500 text-xs mt-1">
                  Service: {a.service.name} ({a.service.location})
                </div>
              </div>
              <div className="flex flex-col gap-3">
                <button
                  onClick={() => patchAction(a.id, "accept")}
                  className="bg-green-100 hover:bg-green-200 text-green-900 py-2 px-4 rounded text-sm font-medium transition-colors"
                >
                  Accept
                </button>
                <button
                  onClick={() => patchAction(a.id, "reject")}
                  className="bg-red-100 hover:bg-red-200 text-red-900 py-2 px-4 rounded text-sm font-medium transition-colors"
                >
                  Reject
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Scheduled Appointments */}
      <div>
        <h3 className="text-xl font-semibold text-gray-800 mb-4">
          Scheduled Appointments
        </h3>
        {scheduledAppointments.length === 0 && (
          <div className="text-center text-gray-500 py-8">
            No scheduled appointments.
          </div>
        )}
        <div className="space-y-4">
          {scheduledAppointments.map((a) => (
            <div
              key={a.id}
              className="bg-white rounded-lg shadow-sm p-6 border border-green-200 flex justify-between items-start"
            >
              <div>
                <strong className="text-lg text-gray-800 block mb-1">
                  {a.guest_name}
                </strong>
                <div className="text-gray-600 text-sm mb-1">
                  {a.guest_email}
                </div>
                <div className="text-gray-500 text-xs">
                  Scheduled for: {new Date(a.start_time).toLocaleString()}
                </div>
                <div className="text-gray-500 text-xs mt-1">
                  Service: {a.service.name} ({a.service.location})
                </div>
              </div>
              <div className="flex items-center">
                <span className="text-green-700 font-semibold text-sm">
                  ✓ Confirmed
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
