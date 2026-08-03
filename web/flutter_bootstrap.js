{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  // Serve CanvasKit from the app's own bundle instead of the gstatic CDN so
  // Seizure Compass keeps working fully offline / on restricted networks.
  config: {
    canvasKitBaseUrl: "canvaskit/"
  },
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  }
});
