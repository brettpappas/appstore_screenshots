#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Headless Flutter app for capturing screenshots
Future<void> main(List<String> arguments) async {
  // Parse command line arguments
  final parser = ArgumentParser();
  final args = parser.parse(arguments);

  if (args.showHelp) {
    parser.printUsage();
    exit(0);
  }

  if (args.createConfig) {
    await createSampleConfig(args.configPath);
    print('✅ Sample configuration created at: ${args.configPath}');
    exit(0);
  }

  // Validate config file exists
  final configFile = File(args.configPath);
  if (!await configFile.exists()) {
    print('❌ Config file not found: ${args.configPath}');
    print('Create a config file using the --create-config option first.');
    exit(1);
  }

  try {
    // Load configuration
    final configData = await loadConfiguration(args.configPath);

    // Create and run the headless Flutter app
    final app = HeadlessScreenshotApp(
      configData: configData,
      outputDirectory: args.outputDirectory,
      pixelRatio: args.pixelRatio,
      verbose: args.verbose,
    );

    // Initialize and run the app
    await app.initialize();
    await app.captureScreenshots();

    print('✅ Screenshot capture completed successfully!');
    exit(0);
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

/// Loads configuration from JSON file
Future<Map<String, dynamic>> loadConfiguration(String configPath) async {
  try {
    final configFile = File(configPath);
    final configJson = await configFile.readAsString();
    return json.decode(configJson) as Map<String, dynamic>;
  } catch (e) {
    throw Exception('Failed to load configuration: $e');
  }
}

/// Creates a sample configuration file
Future<void> createSampleConfig(String configPath) async {
  final sampleConfig = {
    "screens": [
      {
        "id": "welcome",
        "title": "Welcome to Amazing App",
        "description": "Experience the next generation of productivity with our intuitive interface.",
        "backgroundColor": "#6C5CE7",
        "templateName": "standard",
        "deviceType": "iphone61",
        "deviceSizeScale": 0.85,
        "showDeviceFrame": true,
        "screenType": "welcome",
      },
      {
        "id": "features",
        "title": "Powerful Features",
        "description": "Discover tools that will transform how you work and boost your productivity.",
        "backgroundColor": "#00B894",
        "templateName": "feature",
        "deviceType": "iphone67",
        "deviceSizeScale": 0.8,
        "showDeviceFrame": false,
        "screenType": "features",
      },
      {
        "id": "dashboard",
        "title": "Beautiful Dashboard",
        "description": "Manage everything from one centralized, intuitive dashboard.",
        "backgroundColor": "#FE9F1B",
        "templateName": "minimal",
        "deviceType": "ipad13",
        "deviceSizeScale": 0.75,
        "showDeviceFrame": true,
        "screenType": "dashboard",
      },
      {
        "id": "android_welcome",
        "title": "Amazing App for Android",
        "description": "Now available on Google Play Store with all the features you love.",
        "backgroundColor": "#2ECC71",
        "templateName": "dynamic",
        "deviceType": "android",
        "deviceSizeScale": 0.85,
        "deviceAlignment": "center",
        "showDeviceFrame": true,
        "screenType": "welcome",
      },
    ],
    "outputDirectory": "app_screenshots",
    "defaultTemplate": "standard",
    "captureDelay": 1000,
  };

  final configFile = File(configPath);
  await configFile.writeAsString(json.encode(sampleConfig));
}

/// Headless Flutter app for capturing screenshots
class HeadlessScreenshotApp {
  final Map<String, dynamic> configData;
  final String? outputDirectory;
  final double pixelRatio;
  final bool verbose;

  late ScreenshotManager _manager;
  late ScreenshotConfig _config;

  HeadlessScreenshotApp({required this.configData, this.outputDirectory, this.pixelRatio = 3.0, this.verbose = false});

  /// Initialize the Flutter binding and screenshot manager
  Future<void> initialize() async {
    // Initialize Flutter binding for headless operation
    WidgetsFlutterBinding.ensureInitialized();

    // Convert JSON config to ScreenshotConfig
    _config = _createScreenshotConfig(configData);

    // Create and configure screenshot manager
    _manager = ScreenshotManager();
    _manager.configure(_config);

    if (verbose) {
      print('🔧 Headless Flutter app initialized');
      print('📁 Output directory: ${outputDirectory ?? _config.outputDirectory}');
      print('🔍 Pixel ratio: $pixelRatio');
      print('📱 Total screens: ${_config.screens.length}');
    }
  }

  /// Capture all screenshots using the headless approach
  Future<void> captureScreenshots() async {
    if (verbose) {
      print('📸 Starting headless screenshot capture...');
    }

    final results = <String>[];

    for (int i = 0; i < _config.screens.length; i++) {
      final screen = _config.screens[i];

      if (verbose) {
        print('📸 Capturing ${screen.id} (${i + 1}/${_config.screens.length})');
      } else {
        stdout.write('\r📸 Progress: ${i + 1}/${_config.screens.length} screens captured');
      }

      try {
        // Add delay between captures if configured
        if (i > 0 && _config.captureDelay > 0) {
          await Future.delayed(Duration(milliseconds: _config.captureDelay));
        }

        // Capture the screenshot using the manager's headless method
        final result = await _manager.captureScreen(
          screenConfig: screen,
          outputPath: outputDirectory,
          pixelRatio: pixelRatio,
        );

        if (result != null) {
          results.add(result);
        }
      } catch (e) {
        print('\n❌ Error capturing ${screen.id}: $e');
        rethrow;
      }
    }

    if (!verbose) {
      print(''); // New line after progress
    }

    print('✅ Successfully captured ${results.length} screenshots:');
    for (final result in results) {
      print('  📄 $result');
    }
  }

  /// Creates a ScreenshotConfig from JSON data
  ScreenshotConfig _createScreenshotConfig(Map<String, dynamic> configData) {
    final screenConfigs = <ScreenConfig>[];

    final screensData = configData['screens'] as List<dynamic>;
    for (final screenData in screensData) {
      final screenMap = screenData as Map<String, dynamic>;
      final screenConfig = _createScreenConfig(screenMap);
      screenConfigs.add(screenConfig);
    }

    return ScreenshotConfig(
      screens: screenConfigs,
      outputDirectory: configData['outputDirectory'] as String? ?? 'screenshots',
      defaultTemplate: configData['defaultTemplate'] as String?,
      captureDelay: configData['captureDelay'] as int? ?? 1000,
    );
  }

  /// Creates a ScreenConfig from JSON data
  ScreenConfig _createScreenConfig(Map<String, dynamic> screenData) {
    final screenType = screenData['screenType'] as String? ?? 'demo';
    final widget = _createScreenWidget(screenType, screenData);

    return ScreenConfig(
      id: screenData['id'] as String,
      screen: widget,
      title: screenData['title'] != null ? Text(screenData['title'] as String) : null,
      description: screenData['description'] != null ? Text(screenData['description'] as String) : null,
      backgroundColor: _parseColor(screenData['backgroundColor'] as String? ?? '#FFFFFF'),
      templateName: screenData['templateName'] as String? ?? 'dynamic',
      fileName: screenData['fileName'] as String?,
      deviceType: _parseDeviceType(screenData['deviceType'] as String? ?? 'iphone61'),
      deviceSizeScale: screenData['deviceSizeScale'] as double?,
      deviceCanvasPosition: screenData['deviceCanvasPosition'] as double?,
      deviceAlignment: _parseDeviceAlignment(screenData['deviceAlignment'] as String?),
      showDeviceFrame: screenData['showDeviceFrame'] as bool? ?? false,
    );
  }

  /// Creates a screen widget based on screen type
  Widget _createScreenWidget(String screenType, Map<String, dynamic> screenData) {
    switch (screenType) {
      case 'welcome':
        return _createWelcomeScreen(screenData);
      case 'features':
        return _createFeaturesScreen(screenData);
      case 'dashboard':
        return _createDashboardScreen(screenData);
      case 'demo':
      default:
        return _createDemoScreen(screenData);
    }
  }

  /// Creates a welcome screen widget
  Widget _createWelcomeScreen(Map<String, dynamic> screenData) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.waving_hand, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              'Get started with our amazing app',
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a features screen widget
  Widget _createFeaturesScreen(Map<String, dynamic> screenData) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Amazing Features',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Discover powerful tools that will transform your workflow',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a dashboard screen widget
  Widget _createDashboardScreen(Map<String, dynamic> screenData) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9A8B), Color(0xFFA8E6CF)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Manage everything from one beautiful interface',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a demo screen widget
  Widget _createDemoScreen(Map<String, dynamic> screenData) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.purple])),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Demo Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text('This is a sample screen for testing', style: TextStyle(fontSize: 16, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  /// Parses a color from hex string
  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  /// Parses device type from string
  DeviceType _parseDeviceType(String deviceTypeString) {
    switch (deviceTypeString.toLowerCase()) {
      case 'iphone55':
        return DeviceType.iphone55;
      case 'iphone61':
        return DeviceType.iphone61;
      case 'iphone67':
        return DeviceType.iphone67;
      case 'ipad13':
        return DeviceType.ipad13;
      case 'android':
        return DeviceType.android;
      default:
        return DeviceType.iphone61;
    }
  }

  /// Parses device alignment from string
  DeviceVerticalAlignment? _parseDeviceAlignment(String? alignmentString) {
    if (alignmentString == null) return null;

    switch (alignmentString.toLowerCase()) {
      case 'top':
        return DeviceVerticalAlignment.top;
      case 'center':
        return DeviceVerticalAlignment.center;
      case 'bottom':
        return DeviceVerticalAlignment.bottom;
      default:
        return null;
    }
  }
}

/// Command line argument parser
class ArgumentParser {
  bool showHelp = false;
  String configPath = 'screenshot_config.json';
  String? outputDirectory;
  double pixelRatio = 3.0;
  bool verbose = false;
  bool createConfig = false;

  ArgumentParser();

  ParsedArguments parse(List<String> arguments) {
    for (int i = 0; i < arguments.length; i++) {
      final arg = arguments[i];

      switch (arg) {
        case '--help':
        case '-h':
          showHelp = true;
          break;
        case '--config':
        case '-c':
          if (i + 1 < arguments.length) {
            configPath = arguments[++i];
          }
          break;
        case '--output':
        case '-o':
          if (i + 1 < arguments.length) {
            outputDirectory = arguments[++i];
          }
          break;
        case '--pixel-ratio':
        case '-p':
          if (i + 1 < arguments.length) {
            pixelRatio = double.tryParse(arguments[++i]) ?? 3.0;
          }
          break;
        case '--verbose':
        case '-v':
          verbose = true;
          break;
        case '--create-config':
          createConfig = true;
          break;
      }
    }

    return ParsedArguments(
      showHelp: showHelp,
      configPath: configPath,
      outputDirectory: outputDirectory,
      pixelRatio: pixelRatio,
      verbose: verbose,
      createConfig: createConfig,
    );
  }

  void printUsage() {
    print('''
AppStore Screenshots CLI Tool

Usage: dart screenshot_cli.dart [options]

Options:
  -h, --help              Show this help message
  -c, --config FILE       Path to configuration file (default: screenshot_config.json)
  -o, --output DIR        Output directory for screenshots (default: from config)
  -p, --pixel-ratio RATIO Pixel ratio for screenshots (default: 3.0)
  -v, --verbose           Enable verbose output
  --create-config         Create a sample configuration file

Examples:
  dart run screenshot_cli.dart
  dart run screenshot_cli.dart --config my_config.json --output ./screenshots
  dart run screenshot_cli.dart --verbose --pixel-ratio 2.0
  dart run screenshot_cli.dart --create-config

Configuration file format:
  The configuration file should be a JSON file defining screen types and properties.
  Use --create-config to generate a sample configuration file.

Device Types:
  - iphone55   (iPhone 5.5", 1080x1920)
  - iphone61   (iPhone 6.1", 1170x2532)
  - iphone67   (iPhone 6.7", 1290x2796)
  - ipad13     (iPad 13", 2048x2732)
  - android    (Android, 1080x1920)

Templates:
  - standard   (Title above, description below device)
  - minimal    (Just the device frame)
  - feature    (Title overlay on device)
  - cutoff     (Device positioned with cutoff effect)
  - dynamic    (Configurable positioning)

Screen Types:
  - welcome    (Welcome screen with gradient)
  - features   (Features showcase screen)
  - dashboard  (Dashboard management screen)
  - demo       (Generic demo screen)

For more information, visit: https://github.com/yourusername/appstore_screenshots
''');
  }
}

/// Parsed command line arguments
class ParsedArguments {
  final bool showHelp;
  final String configPath;
  final String? outputDirectory;
  final double pixelRatio;
  final bool verbose;
  final bool createConfig;

  ParsedArguments({
    required this.showHelp,
    required this.configPath,
    this.outputDirectory,
    required this.pixelRatio,
    required this.verbose,
    required this.createConfig,
  });
}
