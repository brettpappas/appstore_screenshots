import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

void main() {
  group('Screenshot Size Tests', () {
    testWidgets('iPhone 5.5" screenshot should be 1080x1920', (tester) async {
      final manager = ScreenshotManager();

      final config = ScreenConfig(
        id: 'test_iphone55',
        screen: Container(
          color: Colors.blue,
          child: const Center(
            child: Text('Test Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
        title: const Text('Test Title'),
        description: const Text('Test Description'),
        deviceType: DeviceType.iphone55,
        backgroundColor: Colors.white,
      );

      // Build a simple app to provide context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Container(child: const Text('Test App'))),
        ),
      );

      final filePath = await manager.captureScreenWithContext(
        context: tester.element(find.byType(Scaffold)),
        screenConfig: config,
        outputPath: '/tmp',
      );

      expect(filePath, isNotNull);

      if (filePath != null) {
        final file = File(filePath);
        expect(file.existsSync(), isTrue);

        // Read the PNG file and check its dimensions
        final bytes = await file.readAsBytes();
        final image = await decodeImageFromList(bytes);

        print('Image size: ${image.width}x${image.height}');
        print('Expected size: 1080x1920');

        expect(image.width, equals(1080));
        expect(image.height, equals(1920));

        // Clean up
        await file.delete();
      }
    });

    testWidgets('iPhone 6.1" screenshot should be 1170x2532', (tester) async {
      final manager = ScreenshotManager();

      final config = ScreenConfig(
        id: 'test_iphone61',
        screen: Container(
          color: Colors.green,
          child: const Center(
            child: Text('Test Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
        title: const Text('Test Title'),
        description: const Text('Test Description'),
        deviceType: DeviceType.iphone61,
        backgroundColor: Colors.white,
      );

      // Build a simple app to provide context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Container(child: const Text('Test App'))),
        ),
      );

      final filePath = await manager.captureScreenWithContext(
        context: tester.element(find.byType(Scaffold)),
        screenConfig: config,
        outputPath: '/tmp',
      );

      expect(filePath, isNotNull);

      if (filePath != null) {
        final file = File(filePath);
        expect(file.existsSync(), isTrue);

        // Read the PNG file and check its dimensions
        final bytes = await file.readAsBytes();
        final image = await decodeImageFromList(bytes);

        print('Image size: ${image.width}x${image.height}');
        print('Expected size: 1170x2532');

        expect(image.width, equals(1170));
        expect(image.height, equals(2532));

        // Clean up
        await file.delete();
      }
    });
  });
}
