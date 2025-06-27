import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

// Import the CLI functions
import '../bin/screenshot_cli.dart';

void main() {
  group('Example ScreenConfigs CLI Tests', () {
    test('Test CLI with example ScreenConfigs', () async {
      const configPath = 'example_screenshots_config.json';

      // Verify the config file exists
      final configFile = File(configPath);
      expect(await configFile.exists(), true, reason: 'example_screenshots_config.json should exist');

      // Load and validate the configuration
      final configData = await loadConfiguration(configPath);
      expect(configData, isNotNull);
      expect(configData['screens'], isA<List>());

      final screens = configData['screens'] as List<dynamic>;
      expect(screens.length, 6, reason: 'Should have 6 screen configurations matching the example');

      // Verify each screen has the required fields
      for (final screen in screens) {
        final screenMap = screen as Map<String, dynamic>;
        expect(screenMap['id'], isA<String>());
        expect(screenMap['screenType'], isA<String>());
        expect(screenMap['deviceType'], isA<String>());
        print('✓ Screen: ${screenMap['id']} (${screenMap['deviceType']})');
      }

      print('✅ Configuration is valid and ready for screenshot capture!');
    });

    testWidgets('Initialize CLI with example config', (WidgetTester tester) async {
      const configPath = 'example_screenshots_config.json';

      // Load configuration
      final configData = await loadConfiguration(configPath);

      // Create the headless Flutter app
      final app = HeadlessScreenshotApp(
        configData: configData,
        outputDirectory: 'test_example_screenshots',
        pixelRatio: 1.0, // Lower for faster testing
        verbose: true,
      );

      // Test initialization
      await app.initialize();

      print('✅ CLI successfully initialized with example ScreenConfigs!');

      // Clean up test directory if created
      final testDir = Directory('test_example_screenshots');
      if (await testDir.exists()) {
        await testDir.delete(recursive: true);
      }
    });
  });
}
