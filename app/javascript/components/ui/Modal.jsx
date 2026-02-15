import React from "react";

export default function Modal({ open, onClose, children }) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-lg p-6 min-w-[340px] max-w-md w-full mx-4">
        {children}
        <div className="mt-4 text-right">
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 text-sm font-medium transition-colors"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
