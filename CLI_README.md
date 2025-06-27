# AppStore Screenshots CLI Tool

A command-line interface for generating app store screenshots using the `appstore_screenshots` package.

## Quick Start

1. **Create a sample configuration**:

   ```bash
   dart run bin/screenshot_cli.dart --create-config
   ```

2. **Generate screenshots**:

   ```bash
   dart run bin/screenshot_cli.dart
   ```

## Usage

```bash
dart run bin/screenshot_cli.dart [options]
```

### Options

- `-h, --help` - Show help message
- `-c, --config FILE` - Path to configuration file (default: `screenshot_config.json`)
- `-o, --output DIR` - Output directory for screenshots (overrides config)
- `-p, --pixel-ratio RATIO` - Pixel ratio for screenshots (default: 3.0)
- `-v, --verbose` - Enable verbose output
- `--create-config` - Create a sample configuration file

### Examples

```bash
# Generate screenshots with default config
dart run bin/screenshot_cli.dart

# Use custom config and output directory
dart run bin/screenshot_cli.dart --config my_config.json --output ./screenshots

# Verbose output with custom pixel ratio
dart run bin/screenshot_cli.dart --verbose --pixel-ratio 2.0

# Create sample configuration file
dart run bin/screenshot_cli.dart --create-config
```

## Configuration

The CLI tool uses a JSON configuration file to define screens and settings. Use `--create-config` to generate a sample file.

### Configuration Structure

```json
{
  "screens": [
    {
      "id": "welcome",
      "title": "Welcome to Amazing App",
      "description": "Experience the next generation of productivity.",
      "backgroundColor": "#6C5CE7",
      "templateName": "standard",
      "deviceType": "iphone61",
      "deviceSizeScale": 0.85,
      "showDeviceFrame": true,
      "screenType": "welcome"
    }
  ],
  "outputDirectory": "app_screenshots",
  "defaultTemplate": "standard",
  "captureDelay": 1000
}
```

### Screen Properties

- `id` - Unique identifier for the screen
- `title` - Title text to display
- `description` - Description text to display
- `backgroundColor` - Background color (hex format)
- `templateName` - Template to use (see Templates below)
- `deviceType` - Device type (see Device Types below)
- `deviceSizeScale` - Device size ratio (0.0 to 1.0)
- `deviceCanvasPosition` - Canvas position for dynamic template
- `deviceAlignment` - Device alignment (top, center, bottom)
- `showDeviceFrame` - Whether to show device border
- `screenType` - Type of screen content (see Screen Types below)
- `fileName` - Custom filename (optional)

### Device Types

| Device Type | Description | Resolution |
|-------------|-------------|------------|
| `iphone55` | iPhone 5.5" | 1080x1920 |
| `iphone61` | iPhone 6.1" | 1170x2532 |
| `iphone67` | iPhone 6.7" | 1290x2796 |
| `ipad13` | iPad 13" | 2048x2732 |
| `android` | Android | 1080x1920 |

### Templates

| Template | Description |
|----------|-------------|
| `standard` | Title above, description below device |
| `minimal` | Just the device frame |
| `feature` | Title overlay on device |
| `cutoff` | Device positioned with cutoff effect |
| `dynamic` | Configurable positioning |

### Screen Types

The CLI tool includes built-in screen generators:

| Screen Type | Description |
|-------------|-------------|
| `welcome` | Welcome screen with gradient background |
| `features` | Features showcase screen |
| `dashboard` | Dashboard management screen |
| `demo` | Generic demo screen |

## Output

Screenshots are saved as PNG files in the specified output directory. The tool will:

1. Create the output directory if it doesn't exist
2. Generate screenshots for all configured screens
3. Apply the specified templates and styling
4. Save files with the format `{id}.png` or custom filename

## Example Output

After running the CLI tool, you'll get screenshots like:

```
app_screenshots/
├── welcome.png          (iPhone 6.1" welcome screen)
├── features.png         (iPhone 6.7" features screen)
├── dashboard.png        (iPad 13" dashboard screen)
└── android_welcome.png  (Android welcome screen)
```

## Tips

- Use higher pixel ratios (2.0-4.0) for crisp screenshots
- Test different device types to cover all app store requirements
- Use verbose mode (`-v`) to see detailed progress
- The CLI tool runs a headless Flutter app, so it may take a moment to initialize

## Troubleshooting

**Error: Config file not found**

- Run `--create-config` to generate a sample configuration file

**Error: Screenshots not generating**

- Ensure Flutter is properly installed
- Try running with `--verbose` for more details
- Check that the output directory is writable

**Low quality screenshots**

- Increase the pixel ratio with `--pixel-ratio 3.0` or higher
- Ensure sufficient system resources are available
