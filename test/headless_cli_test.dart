import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

// Import the CLI classes and functions
import '../bin/screenshot_cli.dart';

void main() {
  group('Headless CLI Tests', () {
    test('Create config file test', () async {
      // Use a test-specific config path to avoid conflicts
      const testConfigPath = 'test_screenshot_config.json';

      // Clean up any existing test config
      final testConfigFile = File(testConfigPath);
      if (await testConfigFile.exists()) {
        await testConfigFile.delete();
      }

      // Create the sample config
      await createSampleConfig(testConfigPath);

      // Verify the config file was created
      expect(await testConfigFile.exists(), true);

      // Verify it's valid JSON
      final configData = await loadConfiguration(testConfigPath);
      expect(configData, isNotNull);
      expect(configData['screens'], isA<List>());

      // Clean up
      await testConfigFile.delete();
    });

    testWidgets('Test headless app initialization', (WidgetTester tester) async {
      // Create a test config first
      const testConfigPath = 'test_screenshot_config_init.json';
      await createSampleConfig(testConfigPath);

      try {
        // Load configuration
        final configData = await loadConfiguration(testConfigPath);

        // Create the headless Flutter app
        final app = HeadlessScreenshotApp(
          configData: configData,
          outputDirectory: 'test_screenshots',
          pixelRatio: 1.0, // Lower pixel ratio for faster tests
          verbose: true,
        );

        // Initialize the app - this should work in test environment
        await app.initialize();

        // The initialization should succeed
        expect(app, isNotNull);
      } finally {
        // Clean up config file
        final testConfigFile = File(testConfigPath);
        if (await testConfigFile.exists()) {
          await testConfigFile.delete();
        }
      }
    });
  });
}
