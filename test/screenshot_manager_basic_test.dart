import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

void main() {
  group('ScreenshotManager Basic Tests', () {
    test('should create manager and configure', () {
      final manager = ScreenshotManager();

      final config = ScreenshotConfig(
        screens: [
          ScreenConfig(
            id: 'test',
            screen: Container(color: Colors.blue),
            title: Text('Test'),
            description: Text('Test description'),
            deviceType: DeviceType.iphone61,
          ),
        ],
        outputDirectory: 'test_screenshots',
        defaultTemplate: 'standard',
        captureDelay: 100,
      );

      manager.configure(config);

      expect(manager.templateNames, contains('standard'));
      expect(manager.templates.length, greaterThan(0));
    });

    test('should add and remove templates', () {
      final manager = ScreenshotManager();

      final customTemplate = ScreenshotTemplate(name: 'custom', builder: (context, data) => Container());

      manager.addTemplate(customTemplate);
      expect(manager.getTemplate('custom'), isNotNull);

      manager.removeTemplate('custom');
      expect(manager.getTemplate('custom'), isNull);
    });
  });
}
