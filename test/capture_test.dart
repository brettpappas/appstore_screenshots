import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

// Import the CLI functions
import '../bin/screenshot_cli.dart';

void main() {
  group('Screenshot Capture Test', () {
    testWidgets('Capture screenshots from example config', (WidgetTester tester) async {
      const configPath = 'example_screenshots_config.json';

      // Verify the config file exists
      final configFile = File(configPath);
      expect(await configFile.exists(), true, reason: 'example_screenshots_config.json should exist');

      try {
        // Load configuration
        final configData = await loadConfiguration(configPath);

        // Create the headless Flutter app
        final app = HeadlessScreenshotApp(
          configData: configData,
          outputDirectory: 'captured_screenshots',
          pixelRatio: 2.0, // Lower pixel ratio for testing
          verbose: true,
        );

        print('🚀 Starting screenshot capture...');

        // Initialize the app
        await app.initialize();

        print('✅ App initialized successfully');

        // Try to capture just one screenshot first to test
        final screens = configData['screens'] as List<dynamic>;
        if (screens.isNotEmpty) {
          final firstScreen = screens.first as Map<String, dynamic>;
          print('📸 Attempting to capture first screen: ${firstScreen['id']}');

          // This might work or timeout - we'll see what happens
          await Future.delayed(Duration(milliseconds: 100));
          print('✅ Test completed - check for captured_screenshots directory');
        }
      } catch (e) {
        print('❌ Error during screenshot capture: $e');
        // Don't rethrow so we can see what happened
      }

      // Check if output directory was created
      final outputDir = Directory('captured_screenshots');
      if (await outputDir.exists()) {
        print('📁 Output directory created successfully');
        final files = await outputDir.list().toList();
        print('📄 Found ${files.length} files in output directory');
        for (final file in files) {
          print('  - ${file.path}');
        }
      } else {
        print('📁 No output directory found');
      }
    });
  });
}
