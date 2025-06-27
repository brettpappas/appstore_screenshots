# Custom Text Widget Support

The appstore_screenshots package now supports custom Text widgets for both titles and descriptions, giving you complete control over styling, fonts, colors, and spacing.

## Basic Usage

### Using String-based Title/Description (Default)
```dart
ScreenConfig(
  id: 'basic_example',
  screen: MyAppScreen(),
  title: 'My App Title',
  description: 'My app description',
  templateName: 'dynamic',
)
```

### Using Custom Text Widgets
```dart
ScreenConfig(
  id: 'custom_text_example',
  screen: MyAppScreen(),
  title: 'Fallback Title', // Still required for backwards compatibility
  description: 'Fallback Description', // Still required for backwards compatibility
  templateName: 'dynamic',
  // Custom title widget with full styling control
  titleWidget: Text(
    'Custom Styled Title',
    style: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.blue.shade800,
      letterSpacing: 1.2,
      height: 1.1, // Tight line spacing to prevent overlaps
    ),
    textAlign: TextAlign.center,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  ),
  // Custom description widget
  descriptionWidget: Text(
    'This description uses custom styling with precise control over fonts, colors, and spacing.',
    style: TextStyle(
      fontSize: 18,
      color: Colors.blue.shade600,
      height: 1.2, // Tight line spacing
      fontStyle: FontStyle.italic,
      fontFamily: 'SF Pro Display',
    ),
    textAlign: TextAlign.center,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
  ),
)
```

## Advanced Examples

### Rich Text with Multiple Styles
```dart
titleWidget: RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    children: [
      TextSpan(
        text: 'My App',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      TextSpan(
        text: ' Pro',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ],
  ),
)
```

### Custom Widgets with Icons
```dart
titleWidget: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.star, color: Colors.amber, size: 24),
    SizedBox(width: 8),
    Text(
      'Premium App',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  ],
)
```

## Best Practices

### Text Spacing
- Use `height: 1.1` to `1.2` for tighter line spacing to prevent overlaps
- Limit `maxLines` to 2-3 for titles and 2-4 for descriptions
- Always include `overflow: TextOverflow.ellipsis`

### Font Sizes
- Keep font sizes reasonable for the device type
- Use responsive sizing based on device constraints
- Test on different device types (iPhone, iPad, Android)

### Color Accessibility
- Ensure sufficient contrast between text and background colors
- Test readability on different background colors
- Consider using semantic colors from your brand palette

## Template Compatibility

Custom text widgets are supported in all templates:
- **standard**: Title at top, description at bottom
- **dynamic**: Configurable positioning with cutoff effects
- **feature**: Title overlay on device, description below
- **minimal**: Device only (text not shown)

## Migration Guide

Existing code using string-based titles and descriptions will continue to work unchanged. Custom widgets are optional and take precedence when provided.

```dart
// Old approach (still works)
ScreenConfig(
  title: 'My Title',
  description: 'My Description',
)

// New approach (enhanced control)
ScreenConfig(
  title: 'My Title', // Fallback
  description: 'My Description', // Fallback
  titleWidget: CustomTitleWidget(),
  descriptionWidget: CustomDescriptionWidget(),
)
```
