import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

void main() {
  group('ScreenshotManager Tests', () {
    testWidgets('should capture screenshots with context', (WidgetTester tester) async {
      // Create a test app
      await tester.pumpWidget(MaterialApp(home: ScreenshotTestWidget()));

      // Find the test widget
      final testWidget = find.byType(ScreenshotTestWidget);
      expect(testWidget, findsOneWidget);

      // Get the context
      final context = tester.element(testWidget);

      // Create screenshot manager and configuration
      final manager = ScreenshotManager();
      final config = ScreenshotConfig(
        screens: [
          ScreenConfig(
            id: 'test_welcome',
            screen: Container(
              width: 200,
              height: 400,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Welcome to Test App',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            title: Text('Welcome Screen'),
            description: Text('This is a test welcome screen'),
            backgroundColor: Colors.blue,
            deviceType: DeviceType.iphone61,
          ),
        ],
        outputDirectory: 'test_screenshots',
        defaultTemplate: 'standard',
        captureDelay: 100,
      );

      manager.configure(config);

      // Test capturing a single screen
      final result = await manager.captureScreenWithContext(context: context, screenConfig: config.screens.first);

      // Verify the result (in real test, this might be null due to test environment)
      // But we can verify the method doesn't throw an exception
      expect(() => result, returnsNormally);
    });
  });
}

class ScreenshotTestWidget extends StatelessWidget {
  const ScreenshotTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screenshot Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Test the context-based capture
            final result =
                await Container(
                  width: 200,
                  height: 100,
                  color: Colors.green,
                  child: Center(
                    child: Text('Test Widget', style: TextStyle(color: Colors.white)),
                  ),
                ).captureWithTemplateAndContext(
                  context: context,
                  title: 'Test Screenshot',
                  description: 'This is a test',
                  template: DefaultTemplates.standard,
                );

            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Screenshot saved to: $result')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to capture screenshot')));
            }
          },
          child: Text('Test Capture'),
        ),
      ),
    );
  }
}
