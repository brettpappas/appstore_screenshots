import 'screen_config.dart';

/// Configuration for the screenshot automation process
class ScreenshotConfig {
  /// List of screen configurations to capture
  final List<ScreenConfig> screens;

  /// Output directory for saved screenshots
  final String outputDirectory;

  /// Default template name if not specified per screen
  final String? defaultTemplate;

  /// Delay between screenshot captures (in milliseconds)
  final int captureDelay;

  const ScreenshotConfig({
    required this.screens,
    this.outputDirectory = 'screenshots',
    this.defaultTemplate,
    this.captureDelay = 1000,
  });

  /// Creates a copy with modified values
  ScreenshotConfig copyWith({
    List<ScreenConfig>? screens,
    String? outputDirectory,
    String? defaultTemplate,
    int? captureDelay,
  }) {
    return ScreenshotConfig(
      screens: screens ?? this.screens,
      outputDirectory: outputDirectory ?? this.outputDirectory,
      defaultTemplate: defaultTemplate ?? this.defaultTemplate,
      captureDelay: captureDelay ?? this.captureDelay,
    );
  }
}
