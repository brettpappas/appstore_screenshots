# deviceSizeScale Override Guide

The `appstore_screenshots` package now allows you to override the default `deviceSizeScale` for each screenshot, giving you fine-grained control over how much space the device frame occupies within the canvas.

## What is deviceSizeScale?

The `deviceSizeScale` is a value between 0.0 and 1.0 that determines how much of the canvas the device frame should occupy:

- **1.0**: Device fills the entire canvas (no padding/whitespace)
- **0.85**: Device takes up 85% of the canvas (default for iPhones)
- **0.80**: Device takes up 80% of the canvas (default for iPads)
- **0.50**: Device takes up 50% of the canvas (lots of whitespace for dramatic effect)

## Default Values

The package comes with sensible defaults:

```dart
DeviceType.iphone55:  0.85
DeviceType.iphone61:  0.85
DeviceType.iphone67:  0.85
DeviceType.ipad13:    0.80  // iPads get more breathing room
DeviceType.android:   0.85
```

## How to Override deviceSizeScale

### Method 1: Using ScreenConfig (Recommended)

Add the `deviceSizeScale` parameter to your `ScreenConfig`:

```dart
ScreenConfig(
  id: 'my_screenshot',
  screen: MyWidget(),
  title: 'My App Feature',
  description: 'Amazing functionality',
  deviceType: DeviceType.iphone61,
  deviceSizeScale: 0.70, // Custom ratio - device takes 70% of canvas
)
```

### Method 2: Using DeviceSpecs Directly

If you need to work with `DeviceSpecs` directly:

```dart
// Get specs with custom ratio
final customSpecs = DeviceSpecs.forDeviceWithRatio(DeviceType.iphone61, 0.90);

// Use in ScreenshotTemplateData
final templateData = ScreenshotTemplateData(
  screenshot: myWidget,
  title: 'Title',
  description: 'Description',
  backgroundColor: Colors.white,
  deviceType: DeviceType.iphone61,
  deviceSizeScale: 0.90,
);
```

## Complete Example

```dart
import 'package:appstore_screenshots/appstore_screenshots.dart';

void setupScreenshots() {
  final manager = ScreenshotManager();
  
  final config = ScreenshotConfig(
    screens: [
      // Tight fit - device takes 95% of canvas
      ScreenConfig(
        id: 'feature_tight',
        screen: FeatureScreen(),
        title: 'Key Feature',
        description: 'Showcase with minimal whitespace',
        deviceType: DeviceType.iphone61,
        deviceSizeScale: 0.95, // Very tight
      ),
      
      // Spacious - device takes 60% of canvas
      ScreenConfig(
        id: 'hero_spacious',
        screen: HeroScreen(),
        title: 'Hero Feature',
        description: 'Dramatic presentation with lots of whitespace',
        deviceType: DeviceType.iphone67,
        deviceSizeScale: 0.60, // Very spacious
      ),
      
      // Default ratio (no deviceSizeScale specified)
      ScreenConfig(
        id: 'standard',
        screen: StandardScreen(),
        title: 'Standard Layout',
        description: 'Uses default ratio (0.85)',
        deviceType: DeviceType.iphone61,
        // deviceSizeScale not specified = uses default
      ),
    ],
  );
  
  manager.configure(config);
}
```

## Visual Impact

### deviceSizeScale: 0.95 (Tight)

- Device fills most of the canvas
- Minimal whitespace around device
- Good for detailed screenshots where screen content is the focus

### deviceSizeScale: 0.85 (Default)

- Balanced whitespace around device
- Good for most use cases
- Follows Apple's App Store guidelines

### deviceSizeScale: 0.70 (Spacious)

- More whitespace around device
- Good for hero shots and marketing images
- Creates more visual impact with surrounding text/graphics

### deviceSizeScale: 0.50 (Very Spacious)

- Lots of whitespace around device
- Device becomes more of an accent
- Great for artistic presentations or when combined with large text overlays

## Canvas Size vs Image Size

Important distinction:

- **imageSize**: The final output resolution (e.g., 1170x2532 for iPhone 6.1")
- **canvasSize**: The logical canvas for layout, calculated as `deviceSize / deviceSizeScale`
- **deviceSize**: The fixed logical size of the device frame

The `deviceSizeScale` affects the `canvasSize` calculation, which in turn affects how much space is available around the device for text, graphics, and whitespace.

## Best Practices

1. **Tight ratios (0.90+)**: Use for screenshots where the app content is the main focus
2. **Default ratios (0.80-0.85)**: Use for standard App Store screenshots
3. **Spacious ratios (0.60-0.75)**: Use for hero images, marketing materials, or artistic presentations
4. **Very spacious ratios (0.50-0.60)**: Use sparingly for maximum visual impact

## Backward Compatibility

This change is fully backward compatible. If you don't specify `deviceSizeScale`, the default values are used automatically. Existing code will continue to work without any changes.
