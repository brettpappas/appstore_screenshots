# AppStore Screenshots - Developer Guide

## Quick Implementation Guide

### 1. Basic Usage

Add a single screenshot capture to your app:

```dart
import 'package:appstore_screenshots/appstore_screenshots.dart';

// In your widget
final manager = ScreenshotManager();
final result = await manager.captureScreen(
  screenConfig: ScreenConfig(
    id: 'my_screen',
    screen: MyWidget(),
    title: 'Amazing Feature',
    description: 'This feature will blow your mind!',
    backgroundColor: Colors.blue,
  ),
);
```

### 2. Batch Processing

Set up multiple screenshots for automation:

```dart
final config = ScreenshotConfig(
  screens: [
    ScreenConfig(
      id: 'welcome',
      screen: WelcomeScreen(),
      title: 'Welcome',
      description: 'Get started with our app',
      backgroundColor: Colors.purple,
      templateName: 'standard',
    ),
    // Add more screens...
  ],
  outputDirectory: 'app_store_screenshots',
  captureDelay: 2000, // 2 seconds between captures
);

final manager = ScreenshotManager();
manager.configure(config);

final results = await manager.captureAllScreens(
  onProgress: (screenId, current, total) {
    print('Progress: $current/$total - $screenId');
  },
);
```

### 3. Custom Templates

Create your own screenshot layout:

```dart
final customTemplate = ScreenshotTemplate(
  name: 'marketing',
  description: 'Marketing focused template',
  builder: (context, data) => LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Column(
          children: [
            // Your custom layout
            Text(data.title, style: TextStyle(fontSize: 48, color: Colors.white)),
            Expanded(child: data.screenshot),
            Text(data.description, style: TextStyle(fontSize: 24, color: Colors.white70)),
          ],
        ),
      );
    },
  ),
);

manager.addTemplate(customTemplate);
```

### 4. Preview Mode

Show previews during development:

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Preview:'),
      manager.createPreview(
        screenConfig: screenConfig,
        scale: 0.3, // 30% scale for preview
      ),
    ],
  );
}
```

### 5. Extension Method

Use the convenient extension method on any widget:

```dart
final result = await MyWidget().captureWithTemplate(
  title: 'Amazing Feature',
  description: 'This is so cool!',
  template: DefaultTemplates.minimal,
  backgroundColor: Colors.orange,
  fileName: 'feature_screenshot.png',
);
```

## Template Specifications

### App Store Requirements

- **iPhone Screenshots**: 1242 x 2208 pixels
- **Format**: PNG
- **Text**: Readable and well-positioned
- **Quality**: High resolution (3x pixel ratio)

### Built-in Templates

1. **Standard**: Title above device, description below
2. **Minimal**: Clean device frame only
3. **Feature**: Title overlay on device, description below

### Making Templates Responsive

Always use `LayoutBuilder` for responsive templates:

```dart
builder: (context, data) => LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth > 0 ? constraints.maxWidth : 1242;
    final height = constraints.maxHeight > 0 ? constraints.maxHeight : 2208;
    
    // Scale elements based on container size
    final fontSize = (width * 0.04).clamp(16.0, 48.0);
    final deviceSize = (data.deviceSize.width * 1.5).clamp(200.0, width * 0.8);
    
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      // Your layout...
    );
  },
),
```

## File Management

Screenshots are saved to:

- **iOS**: Documents folder / your specified directory
- **Android**: Documents folder / your specified directory
- **Naming**: `{screenId}.png` or custom file name

## Best Practices

1. **Test First**: Always preview screenshots before batch capture
2. **Consistent Branding**: Use consistent colors and fonts across templates
3. **Readable Text**: Ensure text is large enough and has good contrast
4. **Device Frames**: Include realistic device frames with shadows
5. **Automation**: Use progress callbacks for long batch operations

## Troubleshooting

### Common Issues

1. **Widget Not Rendering**: Ensure widgets are built in the widget tree before capture
2. **Text Overflow**: Use `maxLines` and `overflow: TextOverflow.ellipsis`
3. **Size Issues**: Always handle constraints properly in custom templates
4. **File Permissions**: Ensure app has permission to write to documents directory

### Debug Tips

```dart
// Enable debug mode
debugPrint('Capturing ${screenConfig.id}');

// Check template availability
print('Available templates: ${manager.templateNames}');

// Verify configuration
print('Output directory: ${config.outputDirectory}');
```

## Performance Tips

1. **Batch Processing**: Use `captureAllScreens()` instead of multiple single captures
2. **Delays**: Add appropriate delays between captures for heavy widgets
3. **Memory**: Consider memory usage for large batch operations
4. **Pixel Ratio**: Adjust pixel ratio based on quality needs vs. performance

## Integration Examples

### CI/CD Pipeline

```dart
// In your test environment
final manager = ScreenshotManager();
manager.configure(screenshotConfig);
final results = await manager.captureAllScreens();
// Upload results to app store or CI artifacts
```

### Development Workflow

```dart
// Add to your debug builds
if (kDebugMode) {
  FloatingActionButton(
    onPressed: () async {
      await captureCurrentScreen();
    },
    child: Icon(Icons.camera),
  )
}
```
