import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Test to verify the overflow fix in ScreenshotPreview
void main() {
  group('ScreenshotPreview Overflow Fix Tests', () {
    testWidgets('ScreenshotPreview should not overflow with small scale', (WidgetTester tester) async {
      // Create the widget that was causing overflow
      final welcomeScreen = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: const SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 80, color: Colors.white),
              SizedBox(height: 30),
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Get ready to experience something amazing',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );

      final frameWidget = ScreenshotFrameWidget(
        screenshot: welcomeScreen,
        title: Text('Welcome to Amazing App'),
        description: Text('Get started with our intuitive interface.'),
        backgroundColor: const Color(0xFF6C5CE7),
        template: DefaultTemplates.standard,
        deviceType: DeviceType.iphone61,
      );

      final previewWidget = ScreenshotPreview(
        frame: frameWidget,
        scale: 0.3, // This was causing the overflow
      );

      // Build the widget in a test environment
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: previewWidget)),
        ),
      );

      // Verify no overflow errors occurred
      expect(tester.takeException(), isNull);

      // Verify the widget is rendered
      expect(find.byType(ScreenshotPreview), findsOneWidget);
    });

    testWidgets('ScreenshotPreview should work with very small scales', (WidgetTester tester) async {
      final frameWidget = ScreenshotFrameWidget(
        screenshot: Container(
          color: Colors.blue,
          child: const Center(
            child: Text('Test Content', style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
        title: Text('Test Title'),
        description: Text('Test Description'),
        backgroundColor: Colors.white,
        template: DefaultTemplates.minimal,
        deviceType: DeviceType.iphone61,
      );

      final previewWidget = ScreenshotPreview(
        frame: frameWidget,
        scale: 0.1, // Very small scale
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: previewWidget)),
        ),
      );

      // Verify no overflow errors occurred
      expect(tester.takeException(), isNull);

      // Verify the widget is rendered
      expect(find.byType(ScreenshotPreview), findsOneWidget);
    });
  });
}
