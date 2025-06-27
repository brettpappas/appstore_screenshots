import 'package:flutter/material.dart';
import '../screenshot_template.dart';

/// Configuration for a single screen to be captured
class ScreenConfig {
  /// Unique identifier for this screen
  final String id;

  /// Widget to be captured as screenshot
  final Widget screen;

  /// Custom title widget for the frame
  final Widget? title;

  /// Custom description widget for the frame
  final Widget? description;

  /// Background color for the frame
  final Color backgroundColor;

  /// Template name to use for this screen
  final String templateName;

  /// Custom file name for the screenshot (optional)
  final String? fileName;

  /// Device type for this screen
  final DeviceType deviceType;

  /// Custom device ratio (overrides default if provided)
  /// Value between 0.0 and 1.0 representing how much of the canvas the device should occupy
  final double? deviceSizeScale;

  /// Percentage of canvas height where device should be positioned (0.0 to 1.0)
  /// For example: 0.5 means device occupies the bottom 50% of canvas
  final double? deviceCanvasPosition;

  /// Vertical alignment of device within its positioned area
  final DeviceVerticalAlignment? deviceAlignment;

  /// Whether to show a black border frame around the device
  final bool showDeviceFrame;

  const ScreenConfig({
    required this.id,
    required this.screen,
    this.title,
    this.description,
    this.backgroundColor = Colors.white,
    this.templateName = 'dynamic',
    this.fileName,
    this.deviceType = DeviceType.iphone61,
    this.deviceSizeScale,
    this.deviceCanvasPosition,
    this.deviceAlignment,
    this.showDeviceFrame = false,
  });

  /// Creates a copy with modified values
  ScreenConfig copyWith({
    String? id,
    Widget? screen,
    Widget? title,
    Widget? description,
    Color? backgroundColor,
    String? templateName,
    String? fileName,
    DeviceType? deviceType,
    double? deviceSizeScale,
    double? deviceCanvasPosition,
    DeviceVerticalAlignment? deviceAlignment,
    bool? showDeviceFrame,
  }) {
    return ScreenConfig(
      id: id ?? this.id,
      screen: screen ?? this.screen,
      title: title ?? this.title,
      description: description ?? this.description,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      templateName: templateName ?? this.templateName,
      fileName: fileName ?? this.fileName,
      deviceType: deviceType ?? this.deviceType,
      deviceSizeScale: deviceSizeScale ?? this.deviceSizeScale,
      deviceCanvasPosition: deviceCanvasPosition ?? this.deviceCanvasPosition,
      deviceAlignment: deviceAlignment ?? this.deviceAlignment,
      showDeviceFrame: showDeviceFrame ?? this.showDeviceFrame,
    );
  }
}
