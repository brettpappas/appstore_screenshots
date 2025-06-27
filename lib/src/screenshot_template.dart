import 'package:flutter/material.dart';

/// Device types for screenshot generation
enum DeviceType {
  iphone55,

  /// iPhone 6.1" (iPhone 14 Plus, 13 Pro Max, 12 Pro Max, etc.)
  iphone61,

  /// iPhone 6.7" (iPhone 16 Pro Max, 15 Pro Max, 14 Pro Max)
  iphone67,

  /// iPad 13" (iPad Pro 13")
  ipad13,

  /// Android Phone (Generic Android size)
  android,
}

/// Device specifications for different screenshot formats
class DeviceSpecs {
  /// Output image resolution
  final Size imageSize;

  /// Device frame size within the canvas
  final Size deviceSize;

  /// Ratio of device size to canvas size (0.0 to 1.0)
  final double deviceSizeScale;

  /// Device corner radius
  final double cornerRadius;

  /// Shadow blur radius
  final double shadowBlur;

  /// Shadow offset
  final Offset shadowOffset;

  const DeviceSpecs({
    required this.imageSize,
    required this.deviceSize,
    required this.deviceSizeScale,
    required this.cornerRadius,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  /// Calculate canvas size based on device size and ratio
  Size get canvasSize => Size(deviceSize.width / deviceSizeScale, deviceSize.height / deviceSizeScale);

  /// Get device specifications for a given device type
  static DeviceSpecs forDevice(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphone55:
        return const DeviceSpecs(
          imageSize: Size(1080, 1920), // App Store Connect 5.5" iPhone
          deviceSize: Size(414, 736), // Logical size for 5.5" iPhone
          deviceSizeScale: 0.85, // Device takes up 85% of canvas
          cornerRadius: 25,
          shadowBlur: 30,
          shadowOffset: Offset(0, 15),
        );
      case DeviceType.iphone61:
        return const DeviceSpecs(
          imageSize: Size(1170, 2532), // App Store Connect 6.1" iPhone
          deviceSize: Size(390, 844), // Logical size for 6.1" iPhone
          deviceSizeScale: 0.85, // Device takes up 85% of canvas
          cornerRadius: 35,
          shadowBlur: 30,
          shadowOffset: Offset(0, 15),
        );
      case DeviceType.iphone67:
        return const DeviceSpecs(
          imageSize: Size(1290, 2796), // App Store Connect 6.7 & 6.9" iPhone
          deviceSize: Size(430, 932), // Logical size for 6.7" iPhone
          deviceSizeScale: 0.85, // Device takes up 85% of canvas
          cornerRadius: 45,
          shadowBlur: 32,
          shadowOffset: Offset(0, 16),
        );
      case DeviceType.ipad13:
        return const DeviceSpecs(
          imageSize: Size(2048, 2732), // App Store Connect 13" iPad
          deviceSize: Size(1024, 1366), // Logical size for 13" iPad
          deviceSizeScale: 0.8, // Device takes up 80% of canvas (larger device needs more spacing)
          cornerRadius: 50,
          shadowBlur: 40,
          shadowOffset: Offset(0, 20),
        );
      case DeviceType.android:
        return const DeviceSpecs(
          imageSize: Size(1344, 2992), // Google Play Store Android
          deviceSize: Size(448, 998), // Logical size for Android phone
          deviceSizeScale: 0.85, // Device takes up 85% of canvas
          cornerRadius: 38,
          shadowBlur: 25,
          shadowOffset: Offset(0, 12),
        );
    }
  }

  /// Get device specifications for a given device type with custom ratio
  static DeviceSpecs forDeviceWithSize(DeviceType deviceType, double deviceSize) {
    final defaultSpecs = forDevice(deviceType);
    return DeviceSpecs(
      imageSize: defaultSpecs.imageSize,
      deviceSize: defaultSpecs.deviceSize,
      deviceSizeScale: deviceSize,
      cornerRadius: defaultSpecs.cornerRadius,
      shadowBlur: defaultSpecs.shadowBlur,
      shadowOffset: defaultSpecs.shadowOffset,
    );
  }
}

/// Template for creating screenshot frames with different layouts
class ScreenshotTemplate {
  /// Unique name for this template
  final String name;

  /// Function that builds the frame widget
  final Widget Function(BuildContext context, ScreenshotTemplateData data) builder;

  /// Description of this template
  final String description;

  const ScreenshotTemplate({required this.name, required this.builder, this.description = ''});
}

/// Device vertical alignment options
enum DeviceVerticalAlignment {
  /// Align device to top of the specified canvas region
  /// When used with deviceCanvasPosition, creates a top cutoff effect where
  /// only the bottom portion of the device is visible in the top region
  top,

  /// Center device in the specified canvas region
  center,

  /// Align device to bottom of the specified canvas region
  /// When used with deviceCanvasPosition, creates a bottom cutoff effect where
  /// only the top portion of the device is visible in the bottom region
  bottom,
}

/// Data passed to template builders
class ScreenshotTemplateData {
  /// The screenshot image widget
  final Widget screenshot;

  /// Custom title widget for the frame
  final Widget? title;

  /// Custom description widget for the frame
  final Widget? description;

  /// Background color
  final Color backgroundColor;

  /// Device type for screenshot dimensions
  final DeviceType deviceType;

  /// Custom device ratio (overrides default if provided)
  final double? deviceSize;

  /// Percentage of canvas height where device should be positioned (0.0 to 1.0)
  ///
  /// When deviceAlignment is bottom: represents the bottom portion of canvas (e.g., 0.45 = bottom 45%)
  /// When deviceAlignment is top: represents the top portion of canvas (e.g., 0.6 = top 60%)
  /// When deviceAlignment is center: represents the bottom portion where device is centered
  ///
  /// For cutoff effects:
  /// - Bottom cutoff: use deviceAlignment.bottom with desired bottom percentage
  /// - Top cutoff: use deviceAlignment.top with desired top percentage
  final double? deviceCanvasPosition;

  /// Vertical alignment of device within its positioned area
  final DeviceVerticalAlignment deviceAlignment;

  /// Whether to show a black border frame around the device
  final bool showDeviceFrame;

  /// Device frame size (computed from device type)
  Size get deviceFrameSize => DeviceSpecs.forDevice(deviceType).deviceSize;

  /// Canvas size (computed from device type and custom ratio if provided)
  Size get canvasSize {
    final specs = DeviceSpecs.forDevice(deviceType);
    final ratio = deviceSize ?? specs.deviceSizeScale;
    return Size(specs.deviceSize.width / ratio, specs.deviceSize.height / ratio);
  }

  /// Output image size (computed from device type)
  Size get imageSize => DeviceSpecs.forDevice(deviceType).imageSize;

  /// Device specifications (with custom ratio if provided)
  DeviceSpecs get specs {
    final defaultSpecs = DeviceSpecs.forDevice(deviceType);
    if (deviceSize != null) {
      return DeviceSpecs.forDeviceWithSize(deviceType, deviceSize!);
    }
    return defaultSpecs;
  }

  const ScreenshotTemplateData({
    required this.screenshot,
    required this.backgroundColor,
    this.title,
    this.description,
    this.deviceType = DeviceType.iphone61, // Default to iPhone 6.5"
    this.deviceSize,
    this.deviceCanvasPosition,
    this.deviceAlignment = DeviceVerticalAlignment.center,
    this.showDeviceFrame = false,
  });
}

/// Helper function to calculate border width based on device type
double _getDeviceBorderWidth(DeviceType deviceType) {
  switch (deviceType) {
    case DeviceType.iphone55:
      return 14.0; // Smaller phones get thinner border
    case DeviceType.iphone61:
      return 16.0; // Standard phones
    case DeviceType.iphone67:
      return 18.0; // Larger phones get slightly thicker border
    case DeviceType.ipad13:
      return 24.0; // iPads get much thicker border
    case DeviceType.android:
      return 16.0; // Standard for Android
  }
}

/// Predefined templates for common app store layouts
class DefaultTemplates {
  /// Standard template with title above and description below
  static ScreenshotTemplate get standard => ScreenshotTemplate(
    name: 'standard',
    description: 'Standard layout with title above and description below the device',
    builder: (context, data) {
      final specs = data.specs;
      final canvasSize = data.canvasSize; // Use data.canvasSize for custom deviceSize support
      final deviceSize = specs.deviceSize;

      return LayoutBuilder(
        builder: (context, constraints) {
          // Use constraints if available and reasonable, otherwise use canvas sizes
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight;

          // Debug output
          debugPrint('Standard Template Debug:');
          debugPrint('  canvasSize: $canvasSize');
          debugPrint('  deviceSize: $deviceSize');
          debugPrint('  deviceSize: ${data.deviceSize}');
          debugPrint('  constraints: ${constraints.maxWidth} x ${constraints.maxHeight}');

          final useConstraints =
              availableWidth > 0 &&
              availableHeight > 0 &&
              availableWidth < canvasSize.width &&
              availableHeight < canvasSize.height;

          debugPrint('  useConstraints: $useConstraints');

          final containerWidth = useConstraints ? availableWidth : canvasSize.width;
          final containerHeight = useConstraints ? availableHeight : canvasSize.height;
          final scaleFactor = useConstraints ? (availableWidth / canvasSize.width).clamp(0.1, 1.0) : 1.0;

          debugPrint('  containerSize: $containerWidth x $containerHeight');
          debugPrint('  scaleFactor: $scaleFactor');

          final scaledDeviceWidth = deviceSize.width * scaleFactor;
          final scaledDeviceHeight = deviceSize.height * scaleFactor;
          final scaledCornerRadius = specs.cornerRadius * scaleFactor;

          // Calculate device-appropriate border width for standard template
          final baseBorderWidth = _getDeviceBorderWidth(data.deviceType);

          return Container(
            width: containerWidth,
            height: containerHeight,
            color: data.backgroundColor,
            child: Stack(
              children: [
                // Device frame with screenshot - centered and maintains aspect ratio
                Center(
                  child: Container(
                    width: scaledDeviceWidth,
                    height: scaledDeviceHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scaledCornerRadius * 1.25),
                      border: data.showDeviceFrame
                          ? Border.all(color: Colors.black, width: (baseBorderWidth * scaleFactor).clamp(3.0, 36.0))
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: (specs.shadowBlur * scaleFactor).clamp(2.0, 30.0),
                          offset: Offset(0, (specs.shadowOffset.dy * scaleFactor).clamp(2.0, 15.0)),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        data.showDeviceFrame
                            ? ((scaledCornerRadius * 1.25) - (baseBorderWidth * scaleFactor).clamp(3.0, 36.0)).clamp(
                                0.0,
                                scaledCornerRadius * 1.25,
                              )
                            : scaledCornerRadius,
                      ),
                      child: data.screenshot,
                    ),
                  ),
                ),
                // Title - positioned at top with tighter spacing
                Positioned(
                  top: containerHeight * 0.05,
                  left: containerWidth * 0.05,
                  right: containerWidth * 0.05,
                  child:
                      data.title ??
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: (_getTitleFontSize(data.deviceType) * scaleFactor).clamp(14.0, 48.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.1, // Tighter line spacing
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                // Description - positioned at bottom with tighter spacing
                Positioned(
                  bottom: containerHeight * 0.05,
                  left: containerWidth * 0.07,
                  right: containerWidth * 0.07,
                  child:
                      data.description ??
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: (_getDescriptionFontSize(data.deviceType) * scaleFactor).clamp(10.0, 28.0),
                          color: Colors.black54,
                          height: 1.2, // Tighter line spacing
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3, // Reduced from default
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  /// Minimal template with just the device frame
  static ScreenshotTemplate get minimal => ScreenshotTemplate(
    name: 'minimal',
    description: 'Minimal layout with just the device frame',
    builder: (context, data) {
      final specs = data.specs;
      final canvasSize = data.canvasSize; // Use data.canvasSize for custom deviceSizeScale support
      final deviceSize = specs.deviceSize;

      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight;

          final useConstraints =
              availableWidth > 0 &&
              availableHeight > 0 &&
              availableWidth < canvasSize.width &&
              availableHeight < canvasSize.height;

          final containerWidth = useConstraints ? availableWidth : canvasSize.width;
          final containerHeight = useConstraints ? availableHeight : canvasSize.height;
          final scaleFactor = useConstraints ? (availableWidth / canvasSize.width).clamp(0.1, 1.0) : 1.0;

          final scaledDeviceWidth = deviceSize.width * scaleFactor;
          final scaledDeviceHeight = deviceSize.height * scaleFactor;
          final scaledCornerRadius = specs.cornerRadius * scaleFactor;

          // Calculate device-appropriate border width for minimal template
          final baseBorderWidth = _getDeviceBorderWidth(data.deviceType);

          return Container(
            width: containerWidth,
            height: containerHeight,
            color: data.backgroundColor,
            child: Center(
              child: Container(
                width: scaledDeviceWidth,
                height: scaledDeviceHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(scaledCornerRadius * 1.25),
                  border: data.showDeviceFrame
                      ? Border.all(color: Colors.black, width: (baseBorderWidth * scaleFactor).clamp(3.0, 36.0))
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: (specs.shadowBlur * scaleFactor).clamp(2.0, 40.0),
                      offset: Offset(0, (specs.shadowOffset.dy * scaleFactor).clamp(2.0, 20.0)),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    data.showDeviceFrame
                        ? ((scaledCornerRadius * 1.25) - (baseBorderWidth * scaleFactor).clamp(3.0, 36.0)).clamp(
                            0.0,
                            scaledCornerRadius * 1.25,
                          )
                        : scaledCornerRadius,
                  ),
                  child: data.screenshot,
                ),
              ),
            ),
          );
        },
      );
    },
  );

  /// Feature template with title overlay on the device
  static ScreenshotTemplate get feature => ScreenshotTemplate(
    name: 'feature',
    description: 'Feature layout with title overlay and description below',
    builder: (context, data) {
      final specs = data.specs;
      final canvasSize = data.canvasSize; // Use data.canvasSize for custom deviceSizeScale support
      final deviceSize = specs.deviceSize;

      // Calculate device-appropriate border width for feature template
      final baseBorderWidth = _getDeviceBorderWidth(data.deviceType);

      return Container(
        width: canvasSize.width,
        height: canvasSize.height,
        color: data.backgroundColor,
        child: Stack(
          children: [
            // Device frame with title overlay - centered
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: deviceSize.width,
                    height: deviceSize.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(specs.cornerRadius * 1.25),
                      border: data.showDeviceFrame ? Border.all(color: Colors.black, width: baseBorderWidth) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: specs.shadowBlur,
                          offset: specs.shadowOffset,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        data.showDeviceFrame
                            ? ((specs.cornerRadius * 1.25) - baseBorderWidth).clamp(0.0, specs.cornerRadius * 1.25)
                            : specs.cornerRadius,
                      ),
                      child: data.screenshot,
                    ),
                  ),
                  Positioned(
                    top: deviceSize.height * 0.08,
                    left: deviceSize.width * 0.08,
                    right: deviceSize.width * 0.08,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceSize.width * 0.04,
                        vertical: deviceSize.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(specs.cornerRadius * 0.6),
                      ),
                      child: Text(
                        (data.title is Text) ? (data.title as Text).data ?? '' : '',
                        style: TextStyle(
                          fontSize: _getOverlayTitleFontSize(data.deviceType),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Description - positioned at bottom
            Positioned(
              bottom: canvasSize.height * 0.05,
              left: canvasSize.width * 0.08,
              right: canvasSize.width * 0.08,
              child: Text(
                (data.description is Text) ? (data.description as Text).data ?? '' : '',
                style: TextStyle(
                  fontSize: _getDescriptionFontSize(data.deviceType),
                  color: Colors.black54,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    },
  );

  /// Cutoff template with device positioned in bottom 45% with bottom cut off
  static ScreenshotTemplate get cutoff => ScreenshotTemplate(
    name: 'cutoff',
    description: 'Device positioned in bottom 45% with bottom cut off, title and description in top half',
    builder: (context, data) {
      // Use dynamic positioning with fixed settings for cutoff effect
      final dynamicData = ScreenshotTemplateData(
        screenshot: data.screenshot,
        title: data.title,
        description: data.description,
        backgroundColor: data.backgroundColor,
        deviceType: data.deviceType,
        deviceSize: data.deviceSize is double ? data.deviceSize as double : null,
        deviceCanvasPosition: 0.45, // Bottom 45% of canvas
        deviceAlignment: DeviceVerticalAlignment.bottom, // Align to bottom for cutoff effect
        showDeviceFrame: data.showDeviceFrame,
      );

      return dynamic.builder(context, dynamicData);
    },
  );

  /// Dynamic template with configurable device positioning
  static ScreenshotTemplate get dynamic => ScreenshotTemplate(
    name: 'dynamic',
    description: 'Configurable layout with dynamic device positioning and alignment',
    builder: (context, data) {
      final specs = data.specs;
      final canvasSize = data.canvasSize;
      final deviceSize = specs.deviceSize;

      return LayoutBuilder(
        builder: (context, constraints) {
          // Use constraints if available and reasonable, otherwise use canvas sizes
          final availableWidth = constraints.maxWidth;
          final availableHeight = constraints.maxHeight;

          final useConstraints =
              availableWidth > 0 &&
              availableHeight > 0 &&
              availableWidth < canvasSize.width &&
              availableHeight < canvasSize.height;

          final containerWidth = useConstraints ? availableWidth : canvasSize.width;
          final containerHeight = useConstraints ? availableHeight : canvasSize.height;
          final scaleFactor = useConstraints ? (availableWidth / canvasSize.width).clamp(0.1, 1.0) : 1.0;

          // Use normal device scaling based on deviceSizeScale (not affected by positioning)
          final scaledDeviceWidth = deviceSize.width * scaleFactor;
          final scaledDeviceHeight = deviceSize.height * scaleFactor;
          final scaledCornerRadius = specs.cornerRadius * scaleFactor;

          // Calculate device-appropriate border width for dynamic template
          final baseBorderWidth = _getDeviceBorderWidth(data.deviceType);

          // Calculate device positioning (this only affects WHERE the device is placed, not its size)
          // For center alignment, ignore deviceCanvasPosition and default to 1.0 (full canvas)
          final deviceCanvasPosition = data.deviceAlignment == DeviceVerticalAlignment.center
              ? 1.0
              : (data.deviceCanvasPosition ?? 0.45); // Default to 45% for non-center alignments

          double deviceRegionStart;
          double deviceRegionHeight;
          double textRegionStart;
          double textRegionHeight;

          // Determine positioning based on alignment intent
          if (data.deviceAlignment == DeviceVerticalAlignment.top) {
            // For top alignment with cutoff: deviceCanvasPosition represents top portion where device bottom shows
            deviceRegionStart = 0.0;
            deviceRegionHeight = containerHeight * deviceCanvasPosition;
            textRegionStart = deviceRegionHeight;
            textRegionHeight = containerHeight * (1.0 - deviceCanvasPosition);
          } else if (data.deviceAlignment == DeviceVerticalAlignment.center) {
            // For center alignment: device takes full canvas, title on top and description on bottom
            deviceRegionStart = 0.0;
            deviceRegionHeight = containerHeight;
            // For center alignment, use the full container for text, positioned around the device
            textRegionStart = 0.0;
            textRegionHeight = containerHeight;
          } else {
            // For bottom alignment: deviceCanvasPosition represents bottom portion where device shows
            deviceRegionStart = containerHeight * (1.0 - deviceCanvasPosition);
            deviceRegionHeight = containerHeight * deviceCanvasPosition;
            textRegionStart = 0.0;
            textRegionHeight = deviceRegionStart;
          }

          // Debug output
          debugPrint('Dynamic Template Debug:');
          debugPrint('  containerSize: $containerWidth x $containerHeight');
          debugPrint('  deviceCanvasPosition: $deviceCanvasPosition');
          debugPrint('  deviceAlignment: ${data.deviceAlignment}');
          debugPrint('  deviceRegionStart: $deviceRegionStart');
          debugPrint('  deviceRegionHeight: $deviceRegionHeight');
          debugPrint('  textRegionStart: $textRegionStart');
          debugPrint('  textRegionHeight: $textRegionHeight');
          debugPrint('  scaledDeviceSize: $scaledDeviceWidth x $scaledDeviceHeight');

          double deviceTop;
          switch (data.deviceAlignment) {
            case DeviceVerticalAlignment.top:
              // For top alignment with cutoff effect:
              // Position device so that only the bottom portion shows in the specified canvas region
              // Device extends above the visible area
              final visibleDeviceHeight = deviceRegionHeight;
              deviceTop = -(scaledDeviceHeight - visibleDeviceHeight);
              break;
            case DeviceVerticalAlignment.center:
              deviceTop = deviceRegionStart + (deviceRegionHeight - scaledDeviceHeight) / 2;
              break;
            case DeviceVerticalAlignment.bottom:
              // For bottom alignment with cutoff effect:
              // Position device so that only the specified canvas portion shows the device
              // Device extends below the visible area
              final visibleDeviceHeight = deviceRegionHeight;
              deviceTop = containerHeight - visibleDeviceHeight;
              break;
          }

          debugPrint('  calculated deviceTop: $deviceTop');

          final deviceLeft = (containerWidth - scaledDeviceWidth) / 2; // Center horizontally

          // Helper function to build title widget
          Widget buildTitleWidget() {
            if (data.title != null) {
              return data.title!;
            }
            return Text(
              '',
              style: TextStyle(
                fontSize: (_getTitleFontSize(data.deviceType) * scaleFactor).clamp(14.0, 48.0),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.1, // Tighter line spacing
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          }

          // Helper function to build description widget
          Widget buildDescriptionWidget() {
            if (data.description != null) {
              return data.description!;
            }
            return Text(
              '',
              style: TextStyle(
                fontSize: (_getDescriptionFontSize(data.deviceType) * scaleFactor).clamp(10.0, 28.0),
                color: Colors.black54,
                height: 1.2, // Tighter line spacing
              ),
              textAlign: TextAlign.center,
              maxLines: 3, // Reduced from 4 to prevent overlap
              overflow: TextOverflow.ellipsis,
            );
          }

          return Container(
            width: containerWidth,
            height: containerHeight,
            color: data.backgroundColor,
            child: ClipRect(
              child: Stack(
                children: [
                  // Device frame with screenshot - positioned dynamically
                  Positioned(
                    top: deviceTop,
                    left: deviceLeft,
                    child: Container(
                      width: scaledDeviceWidth,
                      height: scaledDeviceHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(scaledCornerRadius * 1.25),
                        border: data.showDeviceFrame
                            ? Border.all(color: Colors.black, width: (baseBorderWidth * scaleFactor).clamp(3.0, 36.0))
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: (specs.shadowBlur * scaleFactor).clamp(2.0, 30.0),
                            offset: Offset(0, (specs.shadowOffset.dy * scaleFactor).clamp(2.0, 15.0)),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          data.showDeviceFrame
                              ? ((scaledCornerRadius * 1.25) - (baseBorderWidth * scaleFactor).clamp(3.0, 36.0)).clamp(
                                  0.0,
                                  scaledCornerRadius * 1.25,
                                )
                              : scaledCornerRadius,
                        ),
                        child: data.screenshot,
                      ),
                    ),
                  ),
                  // Text content - special handling based on alignment
                  if (data.deviceAlignment == DeviceVerticalAlignment.center)
                    // For center alignment: title on top, description on bottom
                    ...(_buildCenterAlignmentText(
                      containerWidth,
                      containerHeight,
                      deviceTop,
                      scaledDeviceHeight,
                      scaleFactor,
                      buildTitleWidget,
                      buildDescriptionWidget,
                    ))
                  else if (textRegionHeight > 0 || data.title != null || data.description != null)
                    // For top/bottom alignment: use text region logic, but always show custom widgets
                    _buildRegionText(
                      containerWidth,
                      textRegionStart,
                      textRegionHeight > 0
                          ? textRegionHeight
                          : containerHeight * 0.3, // Fallback height if no text region
                      scaleFactor,
                      buildTitleWidget,
                      buildDescriptionWidget,
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  /// Get all default templates
  static List<ScreenshotTemplate> get all => [standard, minimal, feature, cutoff, dynamic];

  /// Get title font size based on device type
  static double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphone55:
        return 46.0;
      case DeviceType.iphone61:
        return 48.0;
      case DeviceType.iphone67:
        return 52.0;
      case DeviceType.ipad13:
        return 72.0;
      case DeviceType.android:
        return 42.0;
    }
  }

  /// Get description font size based on device type
  static double _getDescriptionFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphone55:
        return 32.0;
      case DeviceType.iphone61:
        return 32.0;
      case DeviceType.iphone67:
        return 34.0;
      case DeviceType.ipad13:
        return 48.0;
      case DeviceType.android:
        return 28.0;
    }
  }

  /// Get overlay title font size based on device type
  static double _getOverlayTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphone55:
        return 28.0;
      case DeviceType.iphone61:
        return 28.0;
      case DeviceType.iphone67:
        return 30.0;
      case DeviceType.ipad13:
        return 42.0;
      case DeviceType.android:
        return 24.0;
    }
  }

  /// Helper method to build text widgets for center alignment
  /// Title goes above device, description goes below device
  static List<Widget> _buildCenterAlignmentText(
    double containerWidth,
    double containerHeight,
    double deviceTop,
    double deviceHeight,
    double scaleFactor,
    Widget Function() buildTitleWidget,
    Widget Function() buildDescriptionWidget,
  ) {
    final titleHeight = containerHeight * 0.12; // Reserve 12% for title (reduced from 15%)
    final descriptionHeight = containerHeight * 0.12; // Reserve 12% for description (reduced from 15%)
    final titleTopMargin = containerHeight * 0.01; // 1% margin from top (reduced from 2%)
    final descriptionBottomMargin = containerHeight * 0.02; // 1% margin from bottom (reduced from 2%)

    final List<Widget> widgets = [];

    // Always add title if there's content
    widgets.add(
      Positioned(
        top: titleTopMargin,
        left: containerWidth * 0.05,
        right: containerWidth * 0.05,
        height: titleHeight,
        child: Align(alignment: Alignment.topCenter, child: buildTitleWidget()),
      ),
    );

    // Always add description if there's content
    widgets.add(
      Positioned(
        bottom: descriptionBottomMargin,
        left: containerWidth * 0.05,
        right: containerWidth * 0.05,
        height: descriptionHeight,
        child: Align(alignment: Alignment.bottomCenter, child: buildDescriptionWidget()),
      ),
    );

    return widgets;
  }

  /// Helper method to build text widgets for region-based alignment
  static Widget _buildRegionText(
    double containerWidth,
    double textRegionStart,
    double textRegionHeight,
    double scaleFactor,
    Widget Function() buildTitleWidget,
    Widget Function() buildDescriptionWidget,
  ) {
    // Ensure minimum height for text region
    final effectiveTextRegionHeight = textRegionHeight.clamp(50.0, double.infinity);
    final titleTopMargin = (effectiveTextRegionHeight * 0.08).clamp(5.0, 20.0);
    final titleDescriptionGap = (effectiveTextRegionHeight * 0.05).clamp(5.0, 15.0);
    final titleTop = textRegionStart + titleTopMargin;
    final availableHeight = effectiveTextRegionHeight - titleTopMargin;

    return Positioned(
      top: titleTop,
      left: containerWidth * 0.05,
      right: containerWidth * 0.05,
      height: availableHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title takes only the space it needs
          Flexible(flex: 0, child: buildTitleWidget()),
          SizedBox(height: titleDescriptionGap),
          // Description takes remaining space
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: containerWidth * 0.02),
              child: buildDescriptionWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
