import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'screenshot_template.dart';

/// Widget that displays a screenshot with customizable frame and background
class ScreenshotFrameWidget extends StatelessWidget {
  /// The screenshot image to display
  final Widget screenshot;

  /// Custom title widget for the frame
  final Widget? title;

  /// Custom description widget for the frame
  final Widget? description;

  /// Background color for the frame
  final Color backgroundColor;

  /// Template to use for the frame layout
  final ScreenshotTemplate template;

  /// Device type for the frame
  final DeviceType deviceType;

  /// Custom device ratio (overrides default if provided)
  final double? deviceSizeScale;

  /// Percentage of canvas height where device should be positioned (0.0 to 1.0)
  final double? deviceCanvasPosition;

  /// Vertical alignment of device within its positioned area
  final DeviceVerticalAlignment? deviceAlignment;

  /// Whether to show a black border frame around the device
  final bool showDeviceFrame;

  const ScreenshotFrameWidget({
    super.key,
    required this.screenshot,
    required this.template,
    this.title,
    this.description,
    this.backgroundColor = Colors.white,
    this.deviceType = DeviceType.iphone61,
    this.deviceSizeScale,
    this.deviceCanvasPosition,
    this.deviceAlignment,
    this.showDeviceFrame = false,
  });

  @override
  Widget build(BuildContext context) {
    final templateData = ScreenshotTemplateData(
      screenshot: screenshot,
      title: title,
      description: description,
      backgroundColor: backgroundColor,
      deviceType: deviceType,
      deviceSize: deviceSizeScale,
      deviceCanvasPosition: deviceCanvasPosition,
      deviceAlignment: deviceAlignment ?? DeviceVerticalAlignment.center,
      showDeviceFrame: showDeviceFrame,
    );

    return template.builder(context, templateData);
  }
}

/// Widget that can capture its content as an image
class CaptureWidget extends StatefulWidget {
  /// The child widget to capture
  final Widget child;

  /// Global key for capturing
  final GlobalKey repaintBoundaryKey;

  const CaptureWidget({super.key, required this.child, required this.repaintBoundaryKey});

  @override
  State<CaptureWidget> createState() => _CaptureWidgetState();

  /// Static method to capture a widget using its GlobalKey
  static Future<Uint8List?> capture(GlobalKey key, {double pixelRatio = 3.0}) async {
    try {
      final RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('Boundary not found for capture');
        return null;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }
}

class _CaptureWidgetState extends State<CaptureWidget> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: widget.repaintBoundaryKey, child: widget.child);
  }

  /// Captures the widget as a PNG image
  Future<Uint8List?> capture({double pixelRatio = 3.0}) async {
    try {
      final RenderRepaintBoundary boundary =
          widget.repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }
}

/// Helper widget to preview screenshots in development
class ScreenshotPreview extends StatelessWidget {
  /// The frame widget to preview
  final ScreenshotFrameWidget frame;

  /// Scale factor for preview (0.0 to 1.0)
  final double scale;

  const ScreenshotPreview({super.key, required this.frame, this.scale = 0.3});

  @override
  Widget build(BuildContext context) {
    // Calculate canvas size using the same logic as ScreenshotTemplateData
    final specs = DeviceSpecs.forDevice(frame.deviceType);
    final deviceSizeScale = frame.deviceSizeScale ?? specs.deviceSizeScale;
    final canvasSize = Size(specs.deviceSize.width / deviceSizeScale, specs.deviceSize.height / deviceSizeScale);

    // Scale the canvas size for the preview
    final scaledCanvasSize = Size(canvasSize.width * scale, canvasSize.height * scale);

    return GestureDetector(
      onTap: () => _showFullScreenViewer(context, canvasSize),
      child: SizedBox(
        width: scaledCanvasSize.width,
        height: scaledCanvasSize.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: scaledCanvasSize.width,
            height: scaledCanvasSize.height,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(width: canvasSize.width, height: canvasSize.height, child: frame),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenViewer(BuildContext context, Size canvasSize) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenImageViewer(frame: frame, canvasSize: canvasSize),
      ),
    );
  }
}

/// Full-screen image viewer with zoom capabilities
class FullScreenImageViewer extends StatefulWidget {
  /// The frame widget to display
  final ScreenshotFrameWidget frame;

  /// The canvas size for the frame
  final Size canvasSize;

  const FullScreenImageViewer({super.key, required this.frame, required this.canvasSize});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen, color: Colors.white),
            onPressed: _resetZoom,
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.1,
          maxScale: 5.0,
          constrained: false,
          child: SizedBox(width: widget.canvasSize.width, height: widget.canvasSize.height, child: widget.frame),
        ),
      ),
    );
  }

  void _zoomIn() {
    final Matrix4 matrix = _transformationController.value.clone();
    matrix.scale(1.2);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final Matrix4 matrix = _transformationController.value.clone();
    matrix.scale(0.8);
    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }
}
