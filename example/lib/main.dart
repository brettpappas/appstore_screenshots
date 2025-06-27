import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Example demonstrating how to use the appstore_screenshots package
class ScreenshotExample extends StatefulWidget {
  const ScreenshotExample({super.key});

  @override
  State<ScreenshotExample> createState() => _ScreenshotExampleState();
}

class _ScreenshotExampleState extends State<ScreenshotExample> {
  final ScreenshotManager _manager = ScreenshotManager();
  bool _isCapturing = false;
  List<ScreenConfig> _screenConfigs = [];

  // Progress tracking
  int _currentProgress = 0;
  int _totalProgress = 0;
  String _currentScreenId = '';
  String? _lastCreatedZipPath;

  @override
  void initState() {
    super.initState();
    _setupScreenshots();
  }

  void _setupScreenshots() {
    _screenConfigs = [
      ScreenConfig(
        id: 'welcome_iphone55',
        screen: _buildWelcomeScreen(),
        title: Text(
          'iPhone 5.5"',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        description: Text(
          'Experience amazing productivity.',
          style: TextStyle(fontSize: 30, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.amber,
        deviceSizeScale: 0.75,
        deviceType: DeviceType.iphone55,
        showDeviceFrame: true,
      ),
      ScreenConfig(
        id: 'welcome_iphone61_bottom_cutoff',
        screen: _buildWelcomeScreen(),
        title: Text(
          'iPhone 6.1" Bottom Cutoff',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.black, height: 1.1),
          textAlign: TextAlign.center,
        ),
        description: Text(
          'Device positioned with bottom cutoff effect.',
          style: TextStyle(fontSize: 30, color: Colors.black, height: 1.1),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey.shade300,
        deviceType: DeviceType.iphone61,
        deviceCanvasPosition: 0.75, // Device in bottom 75% of canvas
        deviceAlignment: DeviceVerticalAlignment.bottom, // Align to bottom for cutoff effect
        showDeviceFrame: true,
      ),
      ScreenConfig(
        id: 'welcome_iphone61_top_cutoff',
        screen: _buildWelcomeScreen(),
        backgroundColor: Colors.blue.shade200,
        deviceType: DeviceType.iphone61,
        deviceCanvasPosition: 0.5,
        deviceAlignment: DeviceVerticalAlignment.top, // Align to top for cutoff effect
        title: Text(
          'Custom Title Widget',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
          textAlign: TextAlign.center,
        ),
        description: Text(
          'This uses a custom description widget with different styling and tighter spacing.',
          style: TextStyle(fontSize: 38, color: Colors.white, height: 1.1, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
          // maxLines: 2,
          // overflow: TextOverflow.ellipsis,
        ),
        showDeviceFrame: true,
      ),
      ScreenConfig(
        id: 'features_iphone67',
        screen: _buildFeaturesScreen(),
        title: Text(
          'iPhone 6.7" Features',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black, height: 1.0),
          textAlign: TextAlign.center,
        ),
        description: Text(
          'Discover amazing features.',
          style: TextStyle(fontSize: 30, color: Colors.black, height: 1.1),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF00B894),
        deviceType: DeviceType.iphone67,
        deviceSizeScale: 0.95,
        showDeviceFrame: true,
        deviceAlignment: DeviceVerticalAlignment.bottom, // Center alignment for iPhone 6.7"
        deviceCanvasPosition: 0.8, // Centered vertically
      ),
      ScreenConfig(
        id: 'dashboard_ipad',
        screen: _buildDashboardScreen(),
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Beautiful Dashboard',
            style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
            textAlign: TextAlign.center,
          ),
        ),
        description: Text(
          'This is a custom description widget with different styling and tighter spacing.',
          style: TextStyle(fontSize: 40, color: Colors.white, height: 1.1),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.amber.shade700,
        deviceType: DeviceType.ipad13,
        showDeviceFrame: true,
        deviceSizeScale: 0.8,
        deviceCanvasPosition: 0.9,
        deviceAlignment: DeviceVerticalAlignment.center, // Center alignment for iPad
      ),
      ScreenConfig(
        id: 'welcome_android',
        screen: _buildWelcomeScreen(),
        title: Text(
          'Amazing App for Android',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
          textAlign: TextAlign.center,
        ),
        description: Text(
          'Now on Google Play Store.',
          style: TextStyle(fontSize: 36, color: Colors.white, height: 1.1),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF2ECC71),
        deviceType: DeviceType.android,
        deviceSizeScale: 0.75,
        deviceAlignment: DeviceVerticalAlignment.center,
        showDeviceFrame: true,
      ),
    ];

    // Configure the screenshot manager with multiple screens for different device types
    final config = ScreenshotConfig(
      screens: _screenConfigs,
      outputDirectory: 'app_screenshots',
      defaultTemplate: 'standard',
      captureDelay: 1500,
    );

    _manager.configure(config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screenshot Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // const Text(
            //   'App Store Screenshot Generator',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 30),

            // Preview Section
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                height: 260, // Set a fixed height for all preview thumbnails
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _screenConfigs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                        children: [
                          Text(
                            _getDeviceTypeName(_screenConfigs[index].deviceType),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 250,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              child: _manager.createPreview(screenConfig: _screenConfigs[index], scale: 0.15),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Resolution Info Button
            ElevatedButton.icon(
              onPressed: _showScreenshotResolutions,
              icon: const Icon(Icons.info_outline),
              label: const Text('Show Resolution Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade800,
              ),
            ),

            const SizedBox(height: 10),

            // Capture and ZIP Button
            ElevatedButton.icon(
              onPressed: _isCapturing ? null : _captureScreenshotsAsZip,
              icon: const Icon(Icons.archive),
              label: const Text('Generate All Screenshots'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade800,
              ),
            ),

            const SizedBox(height: 10),

            // Access Last ZIP Button (only show if a ZIP was created)
            if (_lastCreatedZipPath != null)
              ElevatedButton.icon(
                onPressed: () => _shareZipFile(_lastCreatedZipPath!),
                icon: Platform.isIOS || Platform.isAndroid ? const Icon(Icons.share) : const Icon(Icons.download),
                label: Platform.isIOS || Platform.isAndroid
                    ? const Text('Share Last ZIP File')
                    : const Text('Download Last ZIP File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade800,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Container(
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
  }

  Widget _buildFeaturesScreen() {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Features',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    _buildFeatureItem(Icons.speed, 'Fast Performance', 'Lightning fast with optimized code'),
                    _buildFeatureItem(Icons.security, 'Secure', 'Your data is protected with encryption'),
                    _buildFeatureItem(Icons.cloud_sync, 'Cloud Sync', 'Sync across all your devices'),
                    _buildFeatureItem(Icons.offline_bolt, 'Offline Mode', 'Works even without internet'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00B894).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF00B894), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardScreen() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFE9F1B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.notifications, color: Color(0xFFFE9F1B)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard('Tasks', '24', Icons.check_circle, Colors.green),
                    _buildDashboardCard('Projects', '8', Icons.folder, Colors.blue),
                    _buildDashboardCard('Messages', '12', Icons.message, Colors.purple),
                    _buildDashboardCard('Analytics', '1.2k', Icons.analytics, Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Future<void> _captureScreenshotsAsZip() async {
    setState(() {
      _isCapturing = true;
      _currentProgress = 0;
      _totalProgress = _screenConfigs.length;
      _currentScreenId = '';
    });

    _showProgressDialog('Creating ZIP File');

    try {
      // Generate a timestamped filename for the ZIP
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final zipFileName = 'app_screenshots_$timestamp.zip';

      final zipPath = await _manager.captureAllScreensAsZipWithContext(
        context: context,
        zipFileName: zipFileName,
        onProgress: (screenId, current, total) {
          debugPrint('Capturing $screenId ($current/$total)');
          _updateProgress(screenId, current, total);
        },
      );

      if (mounted && zipPath != null) {
        // Store the last created ZIP path
        _lastCreatedZipPath = zipPath;

        // Close progress dialog
        Navigator.of(context).pop();

        // Show ZIP file options immediately
        _shareZipFile(zipPath);
      } else if (mounted) {
        // Close progress dialog
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to create ZIP file'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Close progress dialog
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error creating ZIP: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  // Progress dialog for screenshot capture
  void _showProgressDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 16),
              Expanded(child: Text(title)),
            ],
          ),
          content: SizedBox(
            width: 300, // Fixed width to prevent dialog resizing
            child: StreamBuilder<void>(
              stream: Stream.periodic(const Duration(milliseconds: 100)),
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress: $_currentProgress / $_totalProgress',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _totalProgress > 0 ? _currentProgress / _totalProgress : 0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Current: $_currentScreenId',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _updateProgress(String screenId, int current, int total) {
    setState(() {
      _currentScreenId = screenId;
      _currentProgress = current;
      _totalProgress = total;
    });
  }

  void _shareZipFile(String zipPath) async {
    final file = File(zipPath);
    if (await file.exists()) {
      // Use share_plus for mobile platforms
      if (Platform.isIOS || Platform.isAndroid) {
        await _shareZipFileOnMobile(zipPath);
        return;
      }

      // Use alternative options for web
      if (kIsWeb) {
        _showAlternativeOptions(zipPath);
        return;
      }

      // Show full dialog with download option for Desktop
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ZIP File Ready'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your screenshots have been packaged into a ZIP file.'),
                const SizedBox(height: 16),
                Text('File: ${file.path.split('/').last}'),
                FutureBuilder<int>(
                  future: file.length(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sizeKB = (snapshot.data! / 1024).toStringAsFixed(1);
                      return Text('Size: $sizeKB KB');
                    }
                    return const Text('Size: Calculating...');
                  },
                ),
                const SizedBox(height: 16),
                const Text('Choose an option below:', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            actions: [
              // Secondary actions
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Clipboard.setData(ClipboardData(text: zipPath));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📋 File path copied to clipboard!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: const Text('Copy Path'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showFileLocation(zipPath);
                    },
                    child: const Text('Show Location'),
                  ),
                ],
              ),
              // Primary action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _downloadZipFile(zipPath);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download ZIP File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _showFileLocation(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your ZIP file is saved at:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                child: SelectableText(filePath, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
              const SizedBox(height: 16),
              const Text(
                'You can navigate to this location in Finder (macOS) or your file manager to access the ZIP file.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Clipboard.setData(ClipboardData(text: filePath));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📋 File path copied to clipboard!'), backgroundColor: Colors.blue),
                );
              },
              child: const Text('Copy Path'),
            ),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ],
        );
      },
    );
  }

  void _showScreenshotResolutions() {
    // Build resolution information for all screens
    final resolutionInfo = _screenConfigs.map((config) {
      final specs = DeviceSpecs.forDevice(config.deviceType);
      final deviceSizeScale = config.deviceSizeScale ?? specs.deviceSizeScale;
      final canvasSize = Size(specs.deviceSize.width / deviceSizeScale, specs.deviceSize.height / deviceSizeScale);

      return {
        'id': config.id,
        'device_name': _getDeviceTypeName(config.deviceType),
        'output_resolution': '${specs.imageSize.width.toInt()} × ${specs.imageSize.height.toInt()}',
        'canvas_size': '${canvasSize.width.toInt()} × ${canvasSize.height.toInt()}',
        'device_size_scale': '${(deviceSizeScale * 100).toInt()}%',
        'template': config.templateName,
      };
    }).toList();

    // Show dialog with resolution information
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Resolutions'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Screenshots: ${resolutionInfo.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: resolutionInfo.length,
                  itemBuilder: (context, index) {
                    final info = resolutionInfo[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(info['id']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 8),
                            _buildInfoRow('Device:', info['device_name']!),
                            _buildInfoRow('Canvas Size:', info['canvas_size']!),
                            _buildInfoRow('Device Scale:', info['device_size_scale']!),
                            _buildInfoRow('Output:', info['output_resolution']!),
                            // _buildInfoRow('Template:', info['template']!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  String _getDeviceTypeName(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.iphone55:
        return 'iPhone 5.5"';
      case DeviceType.iphone61:
        return 'iPhone 6.1"';
      case DeviceType.iphone67:
        return 'iPhone 6.7"';
      case DeviceType.ipad13:
        return 'iPad 13"';
      case DeviceType.android:
        return 'Android';
    }
  }

  Future<void> _downloadZipFile(String sourceZipPath) async {
    try {
      debugPrint('🔧 Starting download process for: $sourceZipPath');

      final sourceFile = File(sourceZipPath);
      if (!await sourceFile.exists()) {
        debugPrint('❌ Source file does not exist: $sourceZipPath');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('❌ ZIP file not found'), backgroundColor: Colors.red));
        }
        return;
      }

      debugPrint('✅ Source file exists, size: ${await sourceFile.length()} bytes');

      // Use share_plus for mobile platforms
      if (Platform.isIOS || Platform.isAndroid) {
        debugPrint('📱 Mobile platform detected - using share_plus');
        await _shareZipFileOnMobile(sourceZipPath);
        return;
      }

      // Use FilePicker for desktop/web platforms
      if (kIsWeb) {
        debugPrint('� Web detected - using alternative approach');
        _showAlternativeOptions(sourceZipPath);
        return;
      }

      // Get the original filename
      final originalFileName = sourceFile.path.split('/').last;
      debugPrint('📁 Original filename: $originalFileName');

      // Show save dialog (Desktop only)
      debugPrint('🗂️ Opening file picker save dialog...');
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Screenshots ZIP File',
        fileName: originalFileName,
        allowedExtensions: ['zip'],
        type: FileType.custom,
      );

      debugPrint('📍 File picker result: $outputPath');

      if (outputPath != null) {
        debugPrint('💾 User selected path: $outputPath');

        // Show progress indicator
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(), SizedBox(width: 16), Text('Saving ZIP file...')],
              ),
            ),
          );
        }

        debugPrint('📤 Copying file from $sourceZipPath to $outputPath');
        // Copy the file to the selected location
        await sourceFile.copy(outputPath);
        debugPrint('✅ File copy completed');

        if (mounted) {
          // Close progress dialog
          Navigator.of(context).pop();

          // Show success message
          final savedFile = File(outputPath);
          final fileSize = await savedFile.length();
          final fileSizeKB = (fileSize / 1024).toStringAsFixed(1);

          debugPrint('🎉 Success! File saved with size: $fileSizeKB KB');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✅ ZIP file saved successfully!'),
                  Text('📁 Location: ${outputPath.split('/').last}'),
                  Text('💾 Size: $fileSizeKB KB'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        debugPrint('❌ User cancelled file picker dialog');
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error in _downloadZipFile: $e');
      debugPrint('📚 Stack trace: $stackTrace');

      if (mounted) {
        // Close any open dialogs
        try {
          Navigator.of(context).pop();
        } catch (_) {
          // Dialog might not be open
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error saving file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _shareZipFileOnMobile(String zipPath) async {
    try {
      debugPrint('📱 Sharing ZIP file using share_plus: $zipPath');

      final file = File(zipPath);
      final fileName = file.path.split('/').last;
      final fileSize = await file.length();
      final fileSizeKB = (fileSize / 1024).toStringAsFixed(1);

      // Create XFile for sharing
      final xFile = XFile(zipPath, name: fileName, mimeType: 'application/zip');

      // Share the file with a custom message
      final result = await Share.shareXFiles([xFile], subject: 'Screenshot Package');

      debugPrint('📤 Share result: ${result.status}');

      if (mounted) {
        if (result.status == ShareResultStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✅ ZIP file shared successfully!'),
                        Text('📁 File: $fileName ($fileSizeKB KB)'),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (result.status == ShareResultStatus.dismissed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📤 Share cancelled'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error sharing file: $e');
      debugPrint('📚 Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error sharing file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showAlternativeOptions(String zipPath) {
    final file = File(zipPath);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ZIP File Ready'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your screenshots have been packaged into a ZIP file.'),
              const SizedBox(height: 16),
              Text('File: ${file.path.split('/').last}'),
              FutureBuilder<int>(
                future: file.length(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final sizeKB = (snapshot.data! / 1024).toStringAsFixed(1);
                    return Text('Size: $sizeKB KB');
                  }
                  return const Text('Size: Calculating...');
                },
              ),
              const SizedBox(height: 16),
              if (Platform.isIOS)
                const Text(
                  'On iOS, the file is saved to your app\'s documents directory. You can access it through the Files app or copy the path below.',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Clipboard.setData(ClipboardData(text: zipPath));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📋 File path copied to clipboard!'), backgroundColor: Colors.blue),
                );
              },
              child: const Text('Copy Path'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showFileLocation(zipPath);
              },
              child: const Text('Show Location'),
            ),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppStore Screenshots Example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const ScreenshotExample(),
    );
  }
}
