import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Example showing how to generate the same screenshot for multiple languages
/// This approach uses Flutter's localization system to change the app language
/// and generate screenshots for each locale
class MultiLanguageScreenshotExample extends StatefulWidget {
  const MultiLanguageScreenshotExample({super.key});

  @override
  State<MultiLanguageScreenshotExample> createState() => _MultiLanguageScreenshotExampleState();
}

class _MultiLanguageScreenshotExampleState extends State<MultiLanguageScreenshotExample> {
  final ScreenshotManager _manager = ScreenshotManager();
  bool _isCapturing = false;

  // Progress tracking
  int _currentProgress = 0;
  int _totalProgress = 0;
  String _currentScreenId = '';

  // Define the languages you want to support
  final List<LocaleConfig> _supportedLocales = [
    LocaleConfig(locale: const Locale('en'), name: 'English'),
    LocaleConfig(locale: const Locale('es'), name: 'Spanish'),
    LocaleConfig(locale: const Locale('fr'), name: 'French'),
    LocaleConfig(locale: const Locale('de'), name: 'German'),
    LocaleConfig(locale: const Locale('ja'), name: 'Japanese'),
  ];

  @override
  void initState() {
    super.initState();
  }

  /// Generate screenshots for all languages
  Future<void> _generateMultiLanguageScreenshots() async {
    setState(() {
      _isCapturing = true;
      _currentProgress = 0;
      _totalProgress = _supportedLocales.length;
      _currentScreenId = '';
    });

    _showProgressDialog('Generating Multi-Language Screenshots');

    try {
      List<ScreenConfig> allScreenConfigs = [];

      // Generate screen configs for each language
      for (int i = 0; i < _supportedLocales.length; i++) {
        final localeConfig = _supportedLocales[i];

        setState(() {
          _currentProgress = i + 1;
          _currentScreenId = 'Generating ${localeConfig.name} screenshots...';
        });

        // Create screen configs for this locale
        final screenConfigs = _createScreenConfigsForLocale(localeConfig);
        allScreenConfigs.addAll(screenConfigs);

        // Small delay to show progress
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Configure the screenshot manager with all screens
      final config = ScreenshotConfig(
        screens: allScreenConfigs,
        outputDirectory: 'multi_language_screenshots',
        defaultTemplate: 'standard',
        captureDelay: 2000, // Longer delay for language switching
      );

      _manager.configure(config);

      // Generate ZIP file with all language screenshots
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final zipFileName = 'multi_language_screenshots_$timestamp.zip';

      final zipPath = await _manager.captureAllScreensAsZipWithContext(
        context: context,
        zipFileName: zipFileName,
        onProgress: (screenId, current, total) {
          debugPrint('Capturing $screenId ($current/$total)');
          setState(() {
            _currentScreenId = screenId;
            _currentProgress = current;
            _totalProgress = total;
          });
        },
      );

      if (mounted && zipPath != null) {
        Navigator.of(context).pop(); // Close progress dialog
        _showSuccessDialog(zipPath);
      } else if (mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar('Failed to create ZIP file');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar('Error creating screenshots: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  /// Create screen configurations for a specific locale
  List<ScreenConfig> _createScreenConfigsForLocale(LocaleConfig localeConfig) {
    final locale = localeConfig.locale;

    return [
      // Welcome Screen for this language
      ScreenConfig(
        id: 'welcome_${locale.languageCode}_iphone61',
        screen: LocalizedWelcomeScreen(locale: locale),
        title: Text(
          _getLocalizedTitle('Welcome to Amazing App', locale),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        description: Text(
          _getLocalizedDescription('Experience productivity like never before', locale),
          style: const TextStyle(fontSize: 30, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue.shade600,
        deviceType: DeviceType.iphone61,
        showDeviceFrame: true,
        deviceSizeScale: 0.8,
      ),

      // Features Screen for this language
      ScreenConfig(
        id: 'features_${locale.languageCode}_iphone67',
        screen: LocalizedFeaturesScreen(locale: locale),
        title: Text(
          _getLocalizedTitle('Amazing Features', locale),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        description: Text(
          _getLocalizedDescription('Discover what makes our app special', locale),
          style: const TextStyle(fontSize: 30, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green.shade100,
        deviceType: DeviceType.iphone67,
        showDeviceFrame: true,
        deviceSizeScale: 0.85,
      ),

      // Dashboard Screen for this language (iPad)
      ScreenConfig(
        id: 'dashboard_${locale.languageCode}_ipad',
        screen: LocalizedDashboardScreen(locale: locale),
        title: Text(
          _getLocalizedTitle('Your Dashboard', locale),
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        description: Text(
          _getLocalizedDescription('All your important information in one place', locale),
          style: const TextStyle(fontSize: 40, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.purple.shade600,
        deviceType: DeviceType.ipad13,
        showDeviceFrame: true,
        deviceSizeScale: 0.75,
      ),
    ];
  }

  /// Get localized title based on locale
  String _getLocalizedTitle(String key, Locale locale) {
    final translations = {
      'en': {
        'Welcome to Amazing App': 'Welcome to Amazing App',
        'Amazing Features': 'Amazing Features',
        'Your Dashboard': 'Your Dashboard',
      },
      'es': {
        'Welcome to Amazing App': 'Bienvenido a Amazing App',
        'Amazing Features': 'Características Increíbles',
        'Your Dashboard': 'Tu Panel de Control',
      },
      'fr': {
        'Welcome to Amazing App': 'Bienvenue dans Amazing App',
        'Amazing Features': 'Fonctionnalités Incroyables',
        'Your Dashboard': 'Votre Tableau de Bord',
      },
      'de': {
        'Welcome to Amazing App': 'Willkommen bei Amazing App',
        'Amazing Features': 'Erstaunliche Funktionen',
        'Your Dashboard': 'Ihr Dashboard',
      },
      'ja': {
        'Welcome to Amazing App': 'Amazing Appへようこそ',
        'Amazing Features': '素晴らしい機能',
        'Your Dashboard': 'あなたのダッシュボード',
      },
    };

    return translations[locale.languageCode]?[key] ?? key;
  }

  /// Get localized description based on locale
  String _getLocalizedDescription(String key, Locale locale) {
    final translations = {
      'en': {
        'Experience productivity like never before': 'Experience productivity like never before',
        'Discover what makes our app special': 'Discover what makes our app special',
        'All your important information in one place': 'All your important information in one place',
      },
      'es': {
        'Experience productivity like never before': 'Experimenta la productividad como nunca antes',
        'Discover what makes our app special': 'Descubre lo que hace especial a nuestra app',
        'All your important information in one place': 'Toda tu información importante en un solo lugar',
      },
      'fr': {
        'Experience productivity like never before': 'Découvrez la productivité comme jamais auparavant',
        'Discover what makes our app special': 'Découvrez ce qui rend notre app spéciale',
        'All your important information in one place': 'Toutes vos informations importantes en un seul endroit',
      },
      'de': {
        'Experience productivity like never before': 'Erleben Sie Produktivität wie nie zuvor',
        'Discover what makes our app special': 'Entdecken Sie, was unsere App besonders macht',
        'All your important information in one place': 'Alle wichtigen Informationen an einem Ort',
      },
      'ja': {
        'Experience productivity like never before': 'これまでにない生産性を体験してください',
        'Discover what makes our app special': 'このアプリの特別な点を発見してください',
        'All your important information in one place': '重要な情報をすべて一箇所に',
      },
    };

    return translations[locale.languageCode]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Language Screenshots'), backgroundColor: Colors.purple.shade100),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Multi-Language Screenshot Generation',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This example demonstrates how to generate the same screenshot for multiple languages. '
                      'Each language will have its own set of screenshots with localized text.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text('Supported Languages:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _supportedLocales.map((locale) {
                        return Chip(
                          label: Text('${locale.locale.languageCode.toUpperCase()} - ${locale.name}'),
                          backgroundColor: Colors.blue.shade50,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Preview section
            const Text('Preview (English)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPreviewCard('Welcome Screen', LocalizedWelcomeScreen(locale: const Locale('en'))),
                    _buildPreviewCard('Features Screen', LocalizedFeaturesScreen(locale: const Locale('en'))),
                    _buildPreviewCard('Dashboard Screen', LocalizedDashboardScreen(locale: const Locale('en'))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Generate button
            ElevatedButton.icon(
              onPressed: _isCapturing ? null : _generateMultiLanguageScreenshots,
              icon: _isCapturing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.language),
              label: Text(_isCapturing ? 'Generating...' : 'Generate Multi-Language Screenshots'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'This will generate ${_supportedLocales.length * 3} screenshots total (3 screens × ${_supportedLocales.length} languages)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(String title, Widget screen) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(width: 300, height: 600, child: screen),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 16),
              Expanded(child: Text(title)),
            ],
          ),
          content: SizedBox(
            width: 300,
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
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        _currentScreenId,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
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

  void _showSuccessDialog(String zipPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Multi-language screenshots generated successfully!'),
            const SizedBox(height: 12),
            Text('Total screenshots: ${_supportedLocales.length * 3}'),
            Text('Languages: ${_supportedLocales.map((l) => l.name).join(', ')}'),
            const SizedBox(height: 12),
            Text('ZIP file: ${zipPath.split('/').last}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add sharing logic here if needed
            },
            child: const Text('Share ZIP'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
  }
}

/// Configuration for a locale
class LocaleConfig {
  final Locale locale;
  final String name;

  LocaleConfig({required this.locale, required this.name});
}

/// Localized Welcome Screen
class LocalizedWelcomeScreen extends StatelessWidget {
  final Locale locale;

  const LocalizedWelcomeScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.white),
            const SizedBox(height: 30),
            Text(
              _getWelcomeText(locale),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getWelcomeSubtext(locale),
                style: const TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWelcomeText(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return '¡Bienvenido!';
      case 'fr':
        return 'Bienvenue!';
      case 'de':
        return 'Willkommen!';
      case 'ja':
        return 'ようこそ！';
      default:
        return 'Welcome!';
    }
  }

  String _getWelcomeSubtext(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Prepárate para experimentar algo increíble';
      case 'fr':
        return 'Préparez-vous à vivre quelque chose d\'incroyable';
      case 'de':
        return 'Bereiten Sie sich darauf vor, etwas Erstaunliches zu erleben';
      case 'ja':
        return '素晴らしい体験の準備をしてください';
      default:
        return 'Get ready to experience something amazing';
    }
  }
}

/// Localized Features Screen
class LocalizedFeaturesScreen extends StatelessWidget {
  final Locale locale;

  const LocalizedFeaturesScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                _getFeaturesTitle(locale),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              Expanded(child: ListView(children: _getFeatureItems(locale))),
            ],
          ),
        ),
      ),
    );
  }

  String _getFeaturesTitle(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Características';
      case 'fr':
        return 'Fonctionnalités';
      case 'de':
        return 'Funktionen';
      case 'ja':
        return '機能';
      default:
        return 'Features';
    }
  }

  List<Widget> _getFeatureItems(Locale locale) {
    final features = _getLocalizedFeatures(locale);
    return features
        .map(
          (feature) => FeatureItem(
            icon: feature['icon'] as IconData,
            title: feature['title'] as String,
            subtitle: feature['subtitle'] as String,
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _getLocalizedFeatures(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return [
          {'icon': Icons.speed, 'title': 'Rendimiento Rápido', 'subtitle': 'Súper rápido con código optimizado'},
          {'icon': Icons.security, 'title': 'Seguro', 'subtitle': 'Tus datos están protegidos con encriptación'},
          {'icon': Icons.cloud_sync, 'title': 'Sincronización', 'subtitle': 'Sincroniza en todos tus dispositivos'},
          {'icon': Icons.offline_bolt, 'title': 'Modo Offline', 'subtitle': 'Funciona incluso sin internet'},
        ];
      case 'fr':
        return [
          {'icon': Icons.speed, 'title': 'Performance Rapide', 'subtitle': 'Ultra rapide avec du code optimisé'},
          {'icon': Icons.security, 'title': 'Sécurisé', 'subtitle': 'Vos données sont protégées par cryptage'},
          {'icon': Icons.cloud_sync, 'title': 'Sync Cloud', 'subtitle': 'Synchronisez sur tous vos appareils'},
          {'icon': Icons.offline_bolt, 'title': 'Mode Hors Ligne', 'subtitle': 'Fonctionne même sans internet'},
        ];
      case 'de':
        return [
          {'icon': Icons.speed, 'title': 'Schnelle Leistung', 'subtitle': 'Blitzschnell mit optimiertem Code'},
          {'icon': Icons.security, 'title': 'Sicher', 'subtitle': 'Ihre Daten sind durch Verschlüsselung geschützt'},
          {'icon': Icons.cloud_sync, 'title': 'Cloud-Sync', 'subtitle': 'Synchronisierung auf allen Geräten'},
          {'icon': Icons.offline_bolt, 'title': 'Offline-Modus', 'subtitle': 'Funktioniert auch ohne Internet'},
        ];
      case 'ja':
        return [
          {'icon': Icons.speed, 'title': '高速パフォーマンス', 'subtitle': '最適化されたコードで超高速'},
          {'icon': Icons.security, 'title': '安全', 'subtitle': 'データは暗号化で保護されています'},
          {'icon': Icons.cloud_sync, 'title': 'クラウド同期', 'subtitle': 'すべてのデバイスで同期'},
          {'icon': Icons.offline_bolt, 'title': 'オフラインモード', 'subtitle': 'インターネットなしでも動作'},
        ];
      default:
        return [
          {'icon': Icons.speed, 'title': 'Fast Performance', 'subtitle': 'Lightning fast with optimized code'},
          {'icon': Icons.security, 'title': 'Secure', 'subtitle': 'Your data is protected with encryption'},
          {'icon': Icons.cloud_sync, 'title': 'Cloud Sync', 'subtitle': 'Sync across all your devices'},
          {'icon': Icons.offline_bolt, 'title': 'Offline Mode', 'subtitle': 'Works even without internet'},
        ];
    }
  }
}

/// Localized Dashboard Screen
class LocalizedDashboardScreen extends StatelessWidget {
  final Locale locale;

  const LocalizedDashboardScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    _getDashboardTitle(locale),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
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
                  children: _getDashboardCards(locale),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDashboardTitle(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Panel de Control';
      case 'fr':
        return 'Tableau de Bord';
      case 'de':
        return 'Dashboard';
      case 'ja':
        return 'ダッシュボード';
      default:
        return 'Dashboard';
    }
  }

  List<Widget> _getDashboardCards(Locale locale) {
    final cards = _getLocalizedCards(locale);
    return cards
        .map(
          (card) => DashboardCard(
            title: card['title'] as String,
            value: card['value'] as String,
            icon: card['icon'] as IconData,
            color: card['color'] as Color,
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _getLocalizedCards(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return [
          {'title': 'Tareas', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Proyectos', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Mensajes', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Analíticas', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'fr':
        return [
          {'title': 'Tâches', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projets', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Messages', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Analyses', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'de':
        return [
          {'title': 'Aufgaben', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projekte', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Nachrichten', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Analytik', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'ja':
        return [
          {'title': 'タスク', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'プロジェクト', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'メッセージ', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': '分析', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      default:
        return [
          {'title': 'Tasks', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projects', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Messages', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Analytics', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
    }
  }
}

// Reuse the existing FeatureItem and DashboardCard widgets
class FeatureItem extends StatelessWidget {
  const FeatureItem({super.key, required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
}
