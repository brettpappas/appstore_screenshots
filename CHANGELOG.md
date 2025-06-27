# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-06-24

### Added
- Initial release of appstore_screenshots package
- Core screenshot automation functionality
- Three built-in templates: standard, minimal, and feature
- Support for custom templates
- Batch screenshot capture with progress callbacks
- Screenshot preview functionality
- Customizable backgrounds, titles, and descriptions per screen
- Local file storage with configurable output directory
- Widget extension for easy screenshot capture
- Comprehensive example app demonstrating all features
- Full documentation and API reference

### Features
- **ScreenshotManager**: Main class for managing screenshot operations
- **ScreenConfig**: Configuration for individual screens
- **ScreenshotConfig**: Batch configuration for multiple screens
- **ScreenshotTemplate**: Template system for custom layouts
- **ScreenshotFrameWidget**: Widget for displaying framed screenshots
- **CaptureWidget**: Utility widget for screenshot capture
- **ScreenshotPreview**: Preview widget for development

### Templates
- **Standard Template**: Title above, device in center, description below
- **Minimal Template**: Clean layout with just device frame
- **Feature Template**: Title overlay with description below

### Platform Support
- iOS support
- Android support
- Web support (limited)
- Desktop support (limited)

### Dependencies
- path_provider: ^2.1.2 for file system access
- path: ^1.8.3 for path manipulation
- Flutter SDK: >=1.17.0
