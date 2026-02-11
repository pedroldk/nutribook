import React from "react";
import { createRoot } from "react-dom/client";
import App from "./components/App";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("react-root");
  if (el) {
    const root = createRoot(el);
    root.render(<App />);
  }
});
