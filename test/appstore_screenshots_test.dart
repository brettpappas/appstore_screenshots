import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

void main() {
  group('AppStore Screenshots Tests', () {
    testWidgets('ScreenshotManager can be created', (WidgetTester tester) async {
      final manager = ScreenshotManager();
      expect(manager, isNotNull);
      expect(manager.templateNames, isNotEmpty);
      expect(manager.templateNames, contains('standard'));
      expect(manager.templateNames, contains('minimal'));
      expect(manager.templateNames, contains('feature'));
    });

    testWidgets('ScreenConfig can be created', (WidgetTester tester) async {
      final config = ScreenConfig(
        id: 'test_screen',
        screen: const Text('Test Screen'),
        title: Text('Test Title'),
        description: Text('Test Description'),
        deviceType: DeviceType.iphone61,
      );

      expect(config.id, equals('test_screen'));
      expect(config.title, isA<Text>());
      expect(config.description, isA<Text>());
      expect(config.backgroundColor, equals(Colors.white));
      expect(config.deviceType, equals(DeviceType.iphone61));
    });

    testWidgets('ScreenshotFrameWidget can be built', (WidgetTester tester) async {
      final frameWidget = ScreenshotFrameWidget(
        screenshot: const Text('Test Content'),
        title: Text('Test Title'),
        description: Text('Test Description'),
        template: DefaultTemplates.standard,
        deviceType: DeviceType.iphone61,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: frameWidget)));

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('ScreenshotPreview can be displayed', (WidgetTester tester) async {
      final manager = ScreenshotManager();
      final config = ScreenConfig(
        id: 'preview_test',
        screen: const Text('Preview Content'),
        title: Text('Preview Title'),
        description: Text('Preview Description'),
        deviceType: DeviceType.android,
      );

      final preview = manager.createPreview(screenConfig: config);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: preview)));

      expect(find.text('Preview Title'), findsOneWidget);
      expect(find.text('Preview Description'), findsOneWidget);
    });

    test('Custom templates can be added', () {
      final manager = ScreenshotManager();
      final initialCount = manager.templateNames.length;

      final customTemplate = ScreenshotTemplate(
        name: 'custom',
        description: 'Custom template for testing',
        builder: (context, data) => Container(
          color: data.backgroundColor,
          child: Column(children: [data.title ?? Container(), data.screenshot, data.description ?? Container()]),
        ),
      );

      manager.addTemplate(customTemplate);

      expect(manager.templateNames.length, equals(initialCount + 1));
      expect(manager.templateNames, contains('custom'));
      expect(manager.getTemplate('custom'), equals(customTemplate));
    });

    test('Templates can be removed', () {
      final manager = ScreenshotManager();
      final initialCount = manager.templateNames.length;

      manager.removeTemplate('standard');

      expect(manager.templateNames.length, equals(initialCount - 1));
      expect(manager.templateNames, isNot(contains('standard')));
      expect(manager.getTemplate('standard'), isNull);
    });

    test('DeviceSpecs returns correct dimensions', () {
      final iphone61Specs = DeviceSpecs.forDevice(DeviceType.iphone61);
      expect(iphone61Specs.imageSize, equals(const Size(1170, 2532)));
      expect(iphone61Specs.deviceSize, equals(const Size(390, 844)));
      expect(iphone61Specs.deviceSizeScale, equals(0.85));
      expect(iphone61Specs.canvasSize.width, closeTo(458.8, 0.1)); // 390 / 0.85
      expect(iphone61Specs.canvasSize.height, closeTo(993.0, 0.1)); // 844 / 0.85

      final iphone67Specs = DeviceSpecs.forDevice(DeviceType.iphone67);
      expect(iphone67Specs.imageSize, equals(const Size(1290, 2796)));
      expect(iphone67Specs.deviceSize, equals(const Size(430, 932)));
      expect(iphone67Specs.deviceSizeScale, equals(0.85));
      expect(iphone67Specs.canvasSize.width, closeTo(505.9, 0.1)); // 430 / 0.85
      expect(iphone67Specs.canvasSize.height, closeTo(1096.5, 0.1)); // 932 / 0.85

      final ipadSpecs = DeviceSpecs.forDevice(DeviceType.ipad13);
      expect(ipadSpecs.imageSize, equals(const Size(2048, 2732)));
      expect(ipadSpecs.deviceSize, equals(const Size(1024, 1366)));
      expect(ipadSpecs.deviceSizeScale, equals(0.8));
      expect(ipadSpecs.canvasSize.width, closeTo(1280.0, 0.1)); // 1024 / 0.8
      expect(ipadSpecs.canvasSize.height, closeTo(1707.5, 0.1)); // 1366 / 0.8

      final androidSpecs = DeviceSpecs.forDevice(DeviceType.android);
      expect(androidSpecs.imageSize, equals(const Size(1080, 1920)));
      expect(androidSpecs.deviceSize, equals(const Size(443, 994)));
      expect(androidSpecs.deviceSizeScale, equals(0.85));
      expect(androidSpecs.canvasSize.width, closeTo(521.2, 0.1)); // 443 / 0.85
      expect(androidSpecs.canvasSize.height, closeTo(1169.4, 0.1)); // 994 / 0.85
    });

    test('ScreenshotTemplateData computes sizes correctly', () {
      final data = ScreenshotTemplateData(
        screenshot: const Text('Test'),
        title: Text('Title'),
        description: Text('Description'),
        backgroundColor: Colors.blue,
        deviceType: DeviceType.iphone67,
      );

      expect(data.imageSize, equals(const Size(1290, 2796)));
      expect(data.deviceFrameSize, equals(const Size(430, 932)));
      expect(data.canvasSize.width, closeTo(505.9, 0.1)); // 430 / 0.85
      expect(data.canvasSize.height, closeTo(1096.5, 0.1)); // 932 / 0.85
      expect(data.specs.cornerRadius, equals(45.0));
      expect(data.specs.deviceSizeScale, equals(0.85));
    });
  });
}
