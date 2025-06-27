import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'models/screenshot_config.dart';
import 'models/screen_config.dart';
import 'screenshot_template.dart';
import 'screenshot_frame_widget.dart';

/// Main class for managing screenshot automation
class ScreenshotManager {
  /// Map of available templates
  final Map<String, ScreenshotTemplate> _templates = {};

  /// Current configuration
  ScreenshotConfig? _config;

  /// Creates a new ScreenshotManager instance
  ScreenshotManager() {
    // Add default templates
    for (final template in DefaultTemplates.all) {
      _templates[template.name] = template;
    }
  }

  /// Adds a custom template
  void addTemplate(ScreenshotTemplate template) {
    _templates[template.name] = template;
  }

  /// Removes a template
  void removeTemplate(String name) {
    _templates.remove(name);
  }

  /// Gets a template by name
  ScreenshotTemplate? getTemplate(String name) {
    return _templates[name];
  }

  /// Gets all available template names
  List<String> get templateNames => _templates.keys.toList();

  /// Gets all available templates
  List<ScreenshotTemplate> get templates => _templates.values.toList();

  /// Sets the configuration for screenshot automation
  void configure(ScreenshotConfig config) {
    _config = config;
  }

  /// Captures a single screen as a screenshot
  Future<String?> captureScreen({
    required ScreenConfig screenConfig,
    String? outputPath,
    double pixelRatio = 3.0,
  }) async {
    try {
      // Get template
      final templateName = screenConfig.templateName;
      final template = _templates[templateName];

      if (template == null) {
        throw Exception('Template "$templateName" not found');
      }

      // Create the frame widget
      final frameWidget = ScreenshotFrameWidget(
        screenshot: screenConfig.screen,
        title: screenConfig.title,
        description: screenConfig.description,
        backgroundColor: screenConfig.backgroundColor,
        template: template,
        deviceType: screenConfig.deviceType,
        deviceSizeScale: screenConfig.deviceSizeScale,
        deviceCanvasPosition: screenConfig.deviceCanvasPosition,
        deviceAlignment: screenConfig.deviceAlignment,
        showDeviceFrame: screenConfig.showDeviceFrame,
      );

      // Get device specs for sizing (with custom ratio if provided)
      final deviceSpecs = screenConfig.deviceSizeScale != null
          ? DeviceSpecs.forDeviceWithSize(screenConfig.deviceType, screenConfig.deviceSizeScale!)
          : DeviceSpecs.forDevice(screenConfig.deviceType);

      // Debug output
      debugPrint('ScreenshotManager Debug:');
      debugPrint('  screenConfig.deviceSizeScale: ${screenConfig.deviceSizeScale}');
      debugPrint(
        '  deviceSpecs.deviceSizeScale: ${deviceSpecs.deviceSizeScale}',
      ); // TODO: Rename in DeviceSpecs if needed
      debugPrint('  deviceSpecs.canvasSize: ${deviceSpecs.canvasSize}');
      debugPrint('  deviceSpecs.deviceSize: ${deviceSpecs.deviceSize}');

      // Use the direct capture approach
      final imageBytes = await _directCaptureWidget(frameWidget, deviceSpecs.canvasSize, pixelRatio);

      if (imageBytes == null) {
        throw Exception('Failed to capture widget as image');
      }

      // Prepare file path
      final fileName = screenConfig.fileName ?? '${screenConfig.id}.png';
      final directory = outputPath ?? await _getOutputDirectory();
      final filePath = path.join(directory, fileName);

      // Ensure directory exists
      final dirFile = Directory(directory);
      if (!dirFile.existsSync()) {
        dirFile.createSync(recursive: true);
      }

      // Save the image bytes to file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      debugPrint('Screenshot saved to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error capturing screen "${screenConfig.id}": $e');
      return null;
    }
  }

  /// Direct capture approach using RenderRepaintBoundary
  Future<Uint8List?> _directCaptureWidget(Widget widget, Size size, double pixelRatio) async {
    try {
      // Create a render repaint boundary
      final renderRepaintBoundary = RenderRepaintBoundary();

      // Create constrained widget
      final constrainedWidget = ConstrainedBox(
        constraints: BoxConstraints.tight(size),
        child: MediaQuery(
          data: MediaQueryData(size: size, devicePixelRatio: pixelRatio),
          child: Directionality(textDirection: TextDirection.ltr, child: widget),
        ),
      );

      // Create and configure render objects
      final renderView = RenderView(
        view: WidgetsBinding.instance.platformDispatcher.views.first,
        child: renderRepaintBoundary,
      );

      final pipelineOwner = PipelineOwner()..rootNode = renderView;
      renderView.attach(pipelineOwner);

      // Build the widget tree
      final buildOwner = BuildOwner(focusManager: FocusManager());
      final element = constrainedWidget.createElement();

      // Mount element without explicit owner assignment
      element.mount(null, null);

      // Build
      buildOwner.buildScope(element);

      // Get render object and attach
      final renderObject = element.renderObject;
      if (renderObject is RenderBox) {
        renderRepaintBoundary.child = renderObject;
      }

      // Perform layout and painting
      renderView.prepareInitialFrame();
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // Wait for rendering
      await Future.delayed(const Duration(milliseconds: 200));

      // Force another paint cycle
      pipelineOwner.flushPaint();

      // Capture the image
      final image = await renderRepaintBoundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      // Cleanup
      element.unmount();
      renderView.detach();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error in _directCaptureWidget: $e');
      // Fallback to a simpler method if the complex rendering fails
      return await _fallbackCapture(widget, size, pixelRatio);
    }
  }

  /// Fallback capture method - requires live context
  Future<Uint8List?> _fallbackCapture(Widget widget, Size size, double pixelRatio) async {
    debugPrint('Fallback capture method - widget needs to be rendered in live context');
    return null;
  }

  /// Captures a single screen as a screenshot using app context
  Future<String?> captureScreenWithContext({
    required BuildContext context,
    required ScreenConfig screenConfig,
    String? outputPath,
    double pixelRatio = 3.0,
  }) async {
    try {
      // Get template
      final templateName = screenConfig.templateName;
      final template = _templates[templateName];

      if (template == null) {
        throw Exception('Template "$templateName" not found');
      }

      // Create the frame widget
      final frameWidget = ScreenshotFrameWidget(
        screenshot: screenConfig.screen,
        title: screenConfig.title,
        description: screenConfig.description,
        backgroundColor: screenConfig.backgroundColor,
        template: template,
        deviceType: screenConfig.deviceType,
        deviceSizeScale: screenConfig.deviceSizeScale,
        deviceCanvasPosition: screenConfig.deviceCanvasPosition,
        deviceAlignment: screenConfig.deviceAlignment,
        showDeviceFrame: screenConfig.showDeviceFrame,
      );

      // Get device specs for sizing (with custom ratio if provided)
      final deviceSpecs = screenConfig.deviceSizeScale != null
          ? DeviceSpecs.forDeviceWithSize(screenConfig.deviceType, screenConfig.deviceSizeScale!)
          : DeviceSpecs.forDevice(screenConfig.deviceType);

      // Create a global key for the RepaintBoundary
      final globalKey = GlobalKey();

      // Create the widget with RepaintBoundary
      final captureWidget = RepaintBoundary(
        key: globalKey,
        child: SizedBox(
          width: deviceSpecs.canvasSize.width,
          height: deviceSpecs.canvasSize.height,
          child: MediaQuery(
            data: MediaQueryData(size: deviceSpecs.canvasSize, devicePixelRatio: pixelRatio),
            child: frameWidget,
          ),
        ),
      );

      // Insert the widget into an overlay temporarily
      final overlay = Overlay.of(context);
      late OverlayEntry overlayEntry;
      final completer = Completer<Uint8List?>();

      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: -deviceSpecs.canvasSize.width, // Position off-screen
          top: -deviceSpecs.canvasSize.height,
          child: Material(child: captureWidget),
        ),
      );

      // Insert the overlay
      overlay.insert(overlayEntry);

      // Wait for the widget to be rendered and capture it
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // Wait for rendering to complete
          await Future.delayed(const Duration(milliseconds: 500));

          // Capture the image
          final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
          if (boundary != null) {
            final image = await boundary.toImage(pixelRatio: pixelRatio);
            final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
            completer.complete(byteData?.buffer.asUint8List());
          } else {
            completer.complete(null);
          }
        } catch (e) {
          debugPrint('Error capturing in overlay: $e');
          completer.complete(null);
        } finally {
          overlayEntry.remove();
        }
      });

      final imageBytes = await completer.future;

      if (imageBytes == null) {
        throw Exception('Failed to capture widget as image');
      }

      // Prepare file path
      final fileName = screenConfig.fileName ?? '${screenConfig.id}.png';
      final directory = outputPath ?? await _getOutputDirectory();
      final filePath = path.join(directory, fileName);

      // Ensure directory exists
      final dirFile = Directory(directory);
      if (!dirFile.existsSync()) {
        dirFile.createSync(recursive: true);
      }

      // Save the image bytes to file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      debugPrint('Screenshot saved to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error capturing screen with context "${screenConfig.id}": $e');
      return null;
    }
  }

  /// Captures all configured screens automatically using app context
  Future<List<String>> captureAllScreensWithContext({
    required BuildContext context,
    String? outputPath,
    double pixelRatio = 3.0,
    Function(String screenId, int current, int total)? onProgress,
  }) async {
    if (_config == null) {
      throw Exception('No configuration set. Call configure() first.');
    }

    final results = <String>[];
    final total = _config!.screens.length;

    for (int i = 0; i < _config!.screens.length; i++) {
      final screen = _config!.screens[i];

      // Call progress callback
      onProgress?.call(screen.id, i + 1, total);

      // Add delay between captures
      if (i > 0 && _config!.captureDelay > 0) {
        await Future.delayed(Duration(milliseconds: _config!.captureDelay));
      }

      final result = await captureScreenWithContext(
        context: context,
        screenConfig: screen,
        outputPath: outputPath,
        pixelRatio: pixelRatio,
      );

      if (result != null) {
        results.add(result);
      }
    }

    return results;
  }

  /// Captures all screens and creates a ZIP file containing them
  Future<String?> captureAllScreensAsZip({
    String? outputPath,
    double pixelRatio = 3.0,
    String? zipFileName,
    Function(String screenId, int current, int total)? onProgress,
  }) async {
    if (_config == null) {
      throw Exception('No configuration set. Call configure() first.');
    }

    // Capture all screenshots first
    final screenshotPaths = <String>[];
    final total = _config!.screens.length;

    for (int i = 0; i < _config!.screens.length; i++) {
      final screen = _config!.screens[i];

      // Call progress callback
      onProgress?.call(screen.id, i + 1, total);

      // Add delay between captures
      if (i > 0 && _config!.captureDelay > 0) {
        await Future.delayed(Duration(milliseconds: _config!.captureDelay));
      }

      final result = await captureScreen(screenConfig: screen, outputPath: outputPath, pixelRatio: pixelRatio);

      if (result != null) {
        screenshotPaths.add(result);
      }
    }

    if (screenshotPaths.isEmpty) {
      throw Exception('No screenshots were captured');
    }

    // Create ZIP file
    return await createZipFromFiles(filePaths: screenshotPaths, outputPath: outputPath, zipFileName: zipFileName);
  }

  /// Captures all screens and creates a ZIP file containing them (context version)
  Future<String?> captureAllScreensAsZipWithContext({
    required BuildContext context,
    String? outputPath,
    double pixelRatio = 3.0,
    String? zipFileName,
    Function(String screenId, int current, int total)? onProgress,
  }) async {
    if (_config == null) {
      throw Exception('No configuration set. Call configure() first.');
    }

    // Capture all screenshots first
    final screenshotPaths = await captureAllScreensWithContext(
      context: context,
      outputPath: outputPath,
      pixelRatio: pixelRatio,
      onProgress: onProgress,
    );

    if (screenshotPaths.isEmpty) {
      throw Exception('No screenshots were captured');
    }

    // Create ZIP file
    return await createZipFromFiles(filePaths: screenshotPaths, outputPath: outputPath, zipFileName: zipFileName);
  }

  /// Creates a ZIP file from a list of file paths
  Future<String?> createZipFromFiles({required List<String> filePaths, String? outputPath, String? zipFileName}) async {
    try {
      if (filePaths.isEmpty) {
        throw Exception('No files provided to create ZIP');
      }

      // Determine output directory - use current directory if no path provider available
      String directory;
      if (outputPath != null) {
        directory = outputPath;
      } else {
        try {
          directory = await _getOutputDirectory();
        } catch (e) {
          // Fallback to current directory if path provider fails (e.g., in tests)
          directory = Directory.current.path;
        }
      }

      // Generate ZIP filename if not provided
      final fileName = zipFileName ?? 'screenshots_${DateTime.now().millisecondsSinceEpoch}.zip';
      final zipPath = path.join(directory, fileName);

      // Create archive
      final archive = Archive();

      // Add each file to the archive
      for (final filePath in filePaths) {
        final file = File(filePath);
        if (await file.exists()) {
          final fileBytes = await file.readAsBytes();
          final fileName = path.basename(filePath);

          // Create archive file
          final archiveFile = ArchiveFile(fileName, fileBytes.length, fileBytes);
          archive.addFile(archiveFile);

          debugPrint('Added $fileName to ZIP archive');
        } else {
          debugPrint('Warning: File not found: $filePath');
        }
      }

      // Encode the archive as ZIP
      final zipData = ZipEncoder().encode(archive);
      if (zipData == null) {
        throw Exception('Failed to create ZIP archive');
      }

      // Ensure output directory exists
      final dirFile = Directory(directory);
      if (!dirFile.existsSync()) {
        dirFile.createSync(recursive: true);
      }

      // Save ZIP file
      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipData);

      debugPrint('ZIP file created successfully: $zipPath');
      debugPrint('ZIP file size: ${(zipData.length / 1024).toStringAsFixed(1)} KB');
      debugPrint('Contains ${archive.files.length} files');

      return zipPath;
    } catch (e) {
      debugPrint('Error creating ZIP file: $e');
      return null;
    }
  }

  /// Creates a ZIP file from existing screenshots in a directory
  Future<String?> createZipFromDirectory({
    String? sourceDirectory,
    String? outputPath,
    String? zipFileName,
    String filePattern = '*.png',
  }) async {
    try {
      // Determine source directory
      String srcDir;
      if (sourceDirectory != null) {
        srcDir = sourceDirectory;
      } else {
        try {
          srcDir = await _getOutputDirectory();
        } catch (e) {
          // Fallback to current directory if path provider fails
          srcDir = Directory.current.path;
        }
      }

      final directory = Directory(srcDir);

      if (!await directory.exists()) {
        throw Exception('Source directory does not exist: $srcDir');
      }

      // Find all screenshot files
      final files = await directory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.png'))
          .cast<File>()
          .toList();

      if (files.isEmpty) {
        throw Exception('No PNG files found in directory: $srcDir');
      }

      // Get file paths
      final filePaths = files.map((file) => file.path).toList();

      // Create ZIP file
      return await createZipFromFiles(filePaths: filePaths, outputPath: outputPath, zipFileName: zipFileName);
    } catch (e) {
      debugPrint('Error creating ZIP from directory: $e');
      return null;
    }
  }

  /// Gets the output directory path
  Future<String> _getOutputDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final outputDir = Directory(path.join(directory.path, _config?.outputDirectory ?? 'screenshots'));

    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    return outputDir.path;
  }

  /// Creates a preview widget for a screen configuration
  Widget createPreview({required ScreenConfig screenConfig, double scale = 0.3}) {
    final templateName = screenConfig.templateName;
    final template = _templates[templateName];

    if (template == null) {
      return Container(
        width: 100,
        height: 200,
        color: Colors.red,
        child: const Center(
          child: Text('Template not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final frameWidget = ScreenshotFrameWidget(
      screenshot: screenConfig.screen,
      title: screenConfig.title,
      description: screenConfig.description,
      backgroundColor: screenConfig.backgroundColor,
      template: template,
      deviceType: screenConfig.deviceType,
      deviceSizeScale: screenConfig.deviceSizeScale,
      deviceCanvasPosition: screenConfig.deviceCanvasPosition,
      deviceAlignment: screenConfig.deviceAlignment,
      showDeviceFrame: screenConfig.showDeviceFrame,
    );

    return ScreenshotPreview(frame: frameWidget, scale: scale);
  }
}

/// Extension to add screenshot functionality to any widget
extension ScreenshotCapture on Widget {
  /// Captures this widget as a screenshot with the specified template
  Future<String?> captureWithTemplate({
    required String title,
    required String description,
    required ScreenshotTemplate template,
    Color backgroundColor = Colors.white,
    String? fileName,
    String? outputPath,
    double pixelRatio = 3.0,
    DeviceType deviceType = DeviceType.iphone61,
    bool showDeviceFrame = false,
  }) async {
    final manager = ScreenshotManager();
    final config = ScreenConfig(
      id: fileName ?? 'screenshot',
      screen: this,
      title: Text(title),
      description: Text(description),
      backgroundColor: backgroundColor,
      templateName: template.name,
      fileName: fileName,
      deviceType: deviceType,
      showDeviceFrame: showDeviceFrame,
    );

    return manager.captureScreen(screenConfig: config, outputPath: outputPath, pixelRatio: pixelRatio);
  }

  /// Captures this widget as a screenshot with the specified template using app context
  Future<String?> captureWithTemplateAndContext({
    required BuildContext context,
    required String title,
    required String description,
    required ScreenshotTemplate template,
    Color backgroundColor = Colors.white,
    String? fileName,
    String? outputPath,
    double pixelRatio = 3.0,
    DeviceType deviceType = DeviceType.iphone61,
    bool showDeviceFrame = false,
  }) async {
    final manager = ScreenshotManager();
    final config = ScreenConfig(
      id: fileName ?? 'screenshot',
      screen: this,
      title: Text(title),
      description: Text(description),
      backgroundColor: backgroundColor,
      templateName: template.name,
      fileName: fileName,
      deviceType: deviceType,
      showDeviceFrame: showDeviceFrame,
    );

    return manager.captureScreenWithContext(
      context: context,
      screenConfig: config,
      outputPath: outputPath,
      pixelRatio: pixelRatio,
    );
  }
}
