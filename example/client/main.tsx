import React from "react";
window.React = React;

import { Meteor } from "meteor/meteor";
import { createRoot } from "react-dom/client";
import { App } from "/imports/ui/App";

Meteor.startup(() => {
  const container = document.getElementById("react-target");
  const root = createRoot(container!);
  root.render(<App />);
});
