import React from "react";
import { createRoot } from "react-dom/client";
import App from "./components/App";
import Dashboard from "./components/Dashboard";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("react-root");
  if (el) {
    const root = createRoot(el);
    root.render(<App />);
  }

  const d = document.getElementById("dashboard-root");
  if (d) {
    const nutritionistId = d.dataset.nutritionistId;
    const root = createRoot(d);
    root.render(<Dashboard nutritionistId={nutritionistId} />);
  }
});
