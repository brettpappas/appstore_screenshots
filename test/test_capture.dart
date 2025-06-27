import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';
import 'dart:io';

void main() {
  testWidgets('ScreenshotManager captures screenshot', (WidgetTester tester) async {
    final manager = ScreenshotManager();

    final testScreen = Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
      child: const Center(
        child: Text(
          'Test Screenshot',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final config = ScreenConfig(
      id: 'test_capture',
      screen: testScreen,
      title: Text('Test Screenshot'),
      description: Text('Testing if screenshot capture works correctly'),
      backgroundColor: Colors.grey.shade100,
      deviceType: DeviceType.iphone61,
    );

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: testScreen)));
    await tester.pumpAndSettle();

    // Now try to capture
    final result = await manager.captureScreen(screenConfig: config);

    expect(result, isNotNull, reason: 'Screenshot capture should return a file path');
    if (result != null) {
      final file = File(result);
      expect(await file.exists(), isTrue, reason: 'Screenshot file should exist');
      final size = await file.length();
      expect(size, greaterThan(0), reason: 'Screenshot file should not be empty');
    }
  });
}
