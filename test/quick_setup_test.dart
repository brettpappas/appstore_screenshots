import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

// Import the CLI functions
import '../bin/screenshot_cli.dart';

void main() {
  test('Quick screenshot setup test', () async {
    const configPath = 'example_screenshots_config.json';

    // Load configuration
    final configData = await loadConfiguration(configPath);

    print('🚀 Configuration loaded successfully');
    print('📋 Ready to capture screenshots for:');

    final screens = configData['screens'] as List<dynamic>;
    for (int i = 0; i < screens.length; i++) {
      final screen = screens[i] as Map<String, dynamic>;
      print('  ${i + 1}. ${screen['id']} (${screen['deviceType']})');
    }

    print('');
    print('📁 Output directory: ${configData['outputDirectory']}');
    print('🔍 Pixel ratio: 2.0 (for testing)');
    print('⏱️  Capture delay: ${configData['captureDelay']}ms');

    // Create output directory to show it would work
    final outputDir = Directory(configData['outputDirectory'] as String);
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
      print('✅ Created output directory: ${outputDir.path}');
    }

    // Create a sample file to show what would be generated
    final sampleFile = File('${outputDir.path}/sample_screenshot.txt');
    await sampleFile.writeAsString('This would be a screenshot file: welcome_iphone55.png');

    print('✅ Setup completed - ready for screenshot generation!');
    print('📸 Would generate ${screens.length} screenshot files in ${outputDir.path}');
  });
}
