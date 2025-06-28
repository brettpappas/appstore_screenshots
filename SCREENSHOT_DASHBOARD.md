# ScreenshotDashboard Widget

The `ScreenshotDashboard` widget is a comprehensive, ready-to-use dashboard for generating app store screenshots. It encapsulates all the functionality from the example app into a reusable widget that only requires a list of `ScreenConfig` objects.

## Features

- **Preview Interface**: Horizontal scrollable preview of all screenshots
- **Resolution Information**: Detailed resolution info for each device type
- **ZIP Generation**: Generate and share ZIP files with all screenshots
- **Progress Tracking**: Real-time progress updates during generation
- **Cross-platform Support**: Works on iOS, Android, Web, and Desktop
- **Built-in Dependencies**: Includes file_picker and share_plus automatically

## Dependencies Included

This widget automatically includes the following dependencies:
- `file_picker: ^8.1.2` - For desktop file saving
- `share_plus: ^10.0.2` - For mobile sharing

**No additional setup required!** Just use the widget and all functionality is available.

## Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

class MyScreenshotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenshotDashboard(
      screenConfigs: [
        ScreenConfig(
          id: 'welcome_iphone',
          screen: MyWelcomeScreen(),
          title: Text(
            'Welcome to My App',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          description: Text(
            'Experience amazing productivity.',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          deviceType: DeviceType.iphone61,
          showDeviceFrame: true,
        ),
        // Add more screen configurations...
      ],
    );
  }
}
```

## Advanced Usage

```dart
// Use with custom settings
ScreenshotDashboard(
  screenConfigs: myScreenConfigs,
  title: 'My App Screenshots',
  outputDirectory: 'my_app_screenshots',
  captureDelay: 2000, // 2 seconds between captures
  defaultTemplate: 'premium',
)
```

## Parameters

- `screenConfigs` (required): List of screen configurations to generate screenshots for
- `title`: Custom title for the dashboard AppBar
- `outputDirectory`: Directory name for generated screenshots (default: 'app_screenshots')
- `captureDelay`: Delay in milliseconds between captures (default: 1500)
- `defaultTemplate`: Default template name to use (default: 'standard')

## Migration from ScreenshotExample

If you're currently using the full `ScreenshotExample` widget, you can simplify your code by:

1. Extract your `ScreenConfig` list
2. Replace `ScreenshotExample` with `ScreenshotDashboard`
3. Remove all the manual screenshot management code
4. ~~Remove file_picker and share_plus dependencies from your pubspec.yaml~~ (they're now included automatically!)

## What's Different

### Before (with manual setup):
```yaml
# pubspec.yaml
dependencies:
  appstore_screenshots: ^0.0.2
  file_picker: ^8.1.2  # Manual dependency
  share_plus: ^10.0.2  # Manual dependency
```

```dart
// Lots of helper functions and manual setup required
ScreenshotDashboard(
  screenConfigs: myScreenConfigs,
  filePickerSaveFile: createFilePickerSaveFunction(),
  shareFiles: createShareFilesFunction(),
)
```

### After (automatic):
```yaml
# pubspec.yaml
dependencies:
  appstore_screenshots: ^0.0.2  # Dependencies included automatically!
```

```dart
// Simple and clean - no helper functions needed
ScreenshotDashboard(
  screenConfigs: myScreenConfigs,
)
```
