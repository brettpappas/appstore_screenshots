# Device Frame Feature

The app store screenshots package now supports an optional device frame around the device portion of the screenshot. This adds a simple black border around the device to make it more prominent.

## Usage

### Basic Usage

To enable the device frame, set `showDeviceFrame: true` in your `ScreenConfig`:

```dart
final config = ScreenConfig(
  id: 'my_screen',
  screen: myWidget,
  title: 'Amazing Feature',
  description: 'This screenshot shows our amazing feature in action.',
  showDeviceFrame: true, // Enable the black device frame
);
```

### Extension Method Usage

You can also use the device frame with the extension methods:

```dart
// Capture with device frame
await myWidget.captureWithTemplate(
  title: 'My App Feature',
  description: 'A great feature demonstration',
  template: DefaultTemplates.standard,
  showDeviceFrame: true, // Enable the black device frame
);

// Capture with context and device frame
await myWidget.captureWithTemplateAndContext(
  context: context,
  title: 'My App Feature',
  description: 'A great feature demonstration',
  template: DefaultTemplates.standard,
  showDeviceFrame: true, // Enable the black device frame
);
```

### Configuration Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `showDeviceFrame` | `bool` | `false` | Whether to show a black border frame around the device |

### Visual Difference

- **Without device frame**: Clean device rendering with just the shadow
- **With device frame**: Black border (2px scaled) around the device edge

### Template Support

The device frame feature is supported by all built-in templates:

- `standard` - Title above, description below
- `minimal` - Just the device
- `feature` - Title overlay on device
- `cutoff` - Device positioned with cutoff effect
- `dynamic` - Configurable positioning

### Example Comparison

```dart
// Without frame (default)
final configNoFrame = ScreenConfig(
  id: 'no_frame',
  screen: myScreen,
  title: 'Clean Look',
  description: 'Minimal device presentation',
  showDeviceFrame: false, // or omit (default)
);

// With frame
final configWithFrame = ScreenConfig(
  id: 'with_frame',
  screen: myScreen,
  title: 'Framed Look',
  description: 'Device with prominent border',
  showDeviceFrame: true,
);
```

The device frame scales appropriately with different device sizes and pixel ratios to maintain visual consistency across all screenshot outputs.
