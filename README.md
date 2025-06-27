<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# AppStore Screenshots

A Flutter package for automating app store screenshots with customizable backgrounds and templates. Create beautiful, professional screenshots for Apple's App Store and Google Play Store with ease.

## Features

- 🎨 **Multiple Templates**: Choose from predefined templates or create custom ones
- 📱 **Device Frames**: Automatic device frame generation with shadows and styling
- 🔧 **Customizable**: Set custom titles, descriptions, and background colors for each screen
- 🤖 **Automation**: Batch capture multiple screens with a single command
- 📁 **Local Storage**: Save screenshots to a local folder for easy access
- 🖼️ **Preview Mode**: Preview screenshots before capturing
- 🎯 **Easy Integration**: Simple API that works with any Flutter widget

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  appstore_screenshots: ^0.0.1
```

And add the required dependencies:

```yaml
dependencies:
  path_provider: ^2.1.2
  path: ^1.8.3
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Basic Screenshot Capture

```dart
import 'package:appstore_screenshots/appstore_screenshots.dart';

// Create a screen configuration
final screenConfig = ScreenConfig(
  id: 'welcome_screen',
  screen: MyWelcomeScreen(), // Your Flutter widget
  title: 'Welcome to Amazing App',
  description: 'Experience the next generation of mobile productivity.',
  backgroundColor: Colors.blue,
);

// Capture the screenshot
final manager = ScreenshotManager();
final filePath = await manager.captureScreen(screenConfig: screenConfig);
```

### 2. Batch Screenshot Automation with Device Types

```dart
// Configure multiple screens for different device types
final config = ScreenshotConfig(
  screens: [
    ScreenConfig(
      id: 'welcome_iphone61',
      screen: WelcomeScreen(),
      title: 'Welcome to Amazing App',
      description: 'Get started with our intuitive interface.',
      backgroundColor: Color(0xFF6C5CE7),
      templateName: 'standard',
      deviceType: DeviceType.iphone61, // iPhone 6.5" (1242x2208)
    ),
    ScreenConfig(
      id: 'features_iphone67',
      screen: FeaturesScreen(),
      title: 'Powerful Features',
      description: 'Discover tools that boost productivity.',
      backgroundColor: Color(0xFF00B894),
      templateName: 'feature',
      deviceType: DeviceType.iphone67, // iPhone 6.9" (1290x2796)
    ),
    ScreenConfig(
      id: 'dashboard_ipad',
      screen: DashboardScreen(),
      title: 'Beautiful Dashboard',
      description: 'Manage everything from one place.',
      backgroundColor: Color(0xFFFE9F1B),
      templateName: 'minimal',
      deviceType: DeviceType.ipad13, // iPad 13" (2048x2732)
    ),
    ScreenConfig(
      id: 'welcome_android',
      screen: WelcomeScreen(),
      title: 'Amazing App for Android',
      description: 'Now available on Google Play Store.',
      backgroundColor: Color(0xFF2ECC71),
      templateName: 'standard',
      deviceType: DeviceType.android, // Android (1080x1920)
    ),
  ],
  outputDirectory: 'app_screenshots',
  defaultTemplate: 'standard',
  captureDelay: 1500, // Delay between captures
);

// Set configuration and capture all
final manager = ScreenshotManager();
manager.configure(config);

final results = await manager.captureAllScreens(
  onProgress: (screenId, current, total) {
    print('Capturing $screenId ($current/$total)');
  },
);
```

### 3. Preview Screenshots

```dart
// Create a preview widget
final preview = manager.createPreview(
  screenConfig: screenConfig,
  scale: 0.3, // Scale for preview
);

// Use in your widget tree
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Preview:'),
      preview, // Tap to view full-screen with zoom controls!
    ],
  );
}
```

#### Interactive Preview Features

The `ScreenshotPreview` widget now includes interactive features:

- **🔍 Tap to View Full-Screen**: Tap any preview to open a full-screen viewer
- **⚡ Zoom Controls**: Use pinch-to-zoom or the toolbar buttons to zoom in/out
- **🎯 Pan and Navigate**: Pan around zoomed images for detailed inspection
- **🔄 Reset View**: Use the fit-to-screen button to reset zoom and position

This makes it easy to inspect your screenshots in detail during development!

## Device Types

The package supports multiple device types with hard-coded dimensions optimized for App Store and Google Play Store:

### Supported Device Types

- **DeviceType.iphone61**: iPhone 6.5" (1242x2208 pixels) - iPhone 14 Plus, 13 Pro Max, 12 Pro Max
- **DeviceType.iphone67**: iPhone 6.9" (1290x2796 pixels) - iPhone 16 Pro Max, 15 Pro Max, 14 Pro Max  
- **DeviceType.ipad13**: iPad 13" (2048x2732 pixels) - iPad Pro 13"
- **DeviceType.android**: Android (1080x1920 pixels) - Google Play Store standard

Each device type includes:
- Proper canvas dimensions for app store requirements
- Accurate device frame sizes with correct aspect ratios
- Optimized corner radius, shadow blur, and positioning
- Font sizes scaled appropriately for the screen size

### Usage

```dart
ScreenConfig(
  id: 'my_screen',
  screen: MyWidget(),
  title: 'Amazing Feature',
  description: 'This works great on all devices',
  deviceType: DeviceType.iphone67, // Specify device type
  templateName: 'standard',
)
```

## Templates

The package comes with three built-in templates:

### Standard Template
- Title above the device
- Device frame in the center with shadow
- Description below the device
- Perfect for showcasing app features

### Minimal Template
- Just the device frame with shadow
- Clean and simple
- Great for focusing on the app UI

### Feature Template
- Title overlay on the device
- Description below
- Ideal for highlighting specific features

## Custom Templates

Create your own templates for unique layouts:

```dart
final customTemplate = ScreenshotTemplate(
  name: 'custom',
  description: 'My custom template',
  builder: (context, data) => Container(
    width: 1242, // App Store Connect recommended width
    height: 2208, // App Store Connect recommended height
    color: data.backgroundColor,
    child: Column(
      children: [
        // Your custom layout here
        Text(data.title, style: TextStyle(fontSize: 48)),
        Expanded(child: data.screenshot),
        Text(data.description, style: TextStyle(fontSize: 32)),
      ],
    ),
  ),
);

// Add to manager
manager.addTemplate(customTemplate);
```

## Configuration Options

### ScreenConfig

```dart
ScreenConfig(
  id: 'unique_id',              // Required: Unique identifier
  screen: MyWidget(),           // Required: Widget to capture
  title: 'Title Text',          // Required: Title for the frame
  description: 'Description',   // Required: Description text
  backgroundColor: Colors.blue, // Optional: Background color
  templateName: 'standard',     // Optional: Template to use
  fileName: 'custom_name.png',  // Optional: Custom file name
)
```

### ScreenshotConfig

```dart
ScreenshotConfig(
  screens: [/* list of ScreenConfig */], // Required: Screens to capture
  outputDirectory: 'screenshots',        // Optional: Output folder
  defaultTemplate: 'standard',           // Optional: Default template
  captureDelay: 1000,                    // Optional: Delay between captures (ms)
)
```

## File Output

Screenshots are saved as PNG files with the following specifications:
- **Resolution**: 1242x2208 pixels (recommended by App Store Connect)
- **Format**: PNG
- **Location**: Documents directory / your specified folder
- **Naming**: Based on screen ID or custom file name

## Platform Support

- ✅ iOS
- ✅ Android
- ✅ Web (limited)
- ✅ Desktop (limited)

## App Store Guidelines

The generated screenshots follow Apple's App Store Connect guidelines:
- 1242x2208 pixels for iPhone
- High resolution PNG format
- Professional appearance with proper spacing
- Text is readable and well-positioned

## Example App

Check out the complete example in the `example/` folder to see all features in action.

## API Reference

### ScreenshotManager

Main class for managing screenshot operations.

#### Methods

- `configure(ScreenshotConfig config)` - Set the configuration
- `captureScreen({required ScreenConfig screenConfig, ...})` - Capture a single screen
- `captureAllScreens({...})` - Capture all configured screens
- `createPreview({required ScreenConfig screenConfig, ...})` - Create a preview widget
- `addTemplate(ScreenshotTemplate template)` - Add a custom template
- `removeTemplate(String name)` - Remove a template
- `getTemplate(String name)` - Get a template by name

### Templates

#### DefaultTemplates

- `DefaultTemplates.standard` - Standard layout template
- `DefaultTemplates.minimal` - Minimal layout template  
- `DefaultTemplates.feature` - Feature highlight template
- `DefaultTemplates.all` - List of all default templates

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a ⭐ on GitHub!
