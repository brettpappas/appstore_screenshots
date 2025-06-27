// Example usage for cutoff effects:

// Bottom cutoff effect (device extends below visible area):
ScreenConfig(
  templateName: 'dynamic',
  deviceCanvasPosition: 0.45, // Bottom 45% of canvas shows device
  deviceAlignment: DeviceVerticalAlignment.bottom,
  // Result: Device is positioned so only its top portion is visible
)

// Top cutoff effect (device extends above visible area):
ScreenConfig(
  templateName: 'dynamic', 
  deviceCanvasPosition: 0.6, // Top 60% of canvas shows device
  deviceAlignment: DeviceVerticalAlignment.top,
  // Result: Device is positioned so only its bottom portion is visible
)

// Centered device (no cutoff):
ScreenConfig(
  templateName: 'dynamic',
  deviceCanvasPosition: 0.8, // Bottom 80% of canvas allocated for device
  deviceAlignment: DeviceVerticalAlignment.center,
  // Result: Device is centered within the bottom 80% region
)
