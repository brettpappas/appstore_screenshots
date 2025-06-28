import 'package:flutter/material.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Simple example showing how to generate screenshots for 5 different languages
/// This is the minimal approach for basic multi-language screenshot generation
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Multi-Language Screenshots', home: SimpleMultiLanguageExample());
  }
}

class SimpleMultiLanguageExample extends StatelessWidget {
  // Define your supported languages
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'ja', 'name': 'Japanese'},
  ];

  SimpleMultiLanguageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Create screen configs for all languages
    List<ScreenConfig> allScreenConfigs = [];

    for (final language in languages) {
      final languageCode = language['code']!;

      // Add screens for this language
      allScreenConfigs.addAll([
        // Welcome screen for iPhone 6.1"
        ScreenConfig(
          id: 'welcome_${languageCode}_iphone61',
          screen: WelcomeScreen(languageCode: languageCode),
          title: Text(
            _getTitle(languageCode, 'welcome'),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          description: Text(
            _getDescription(languageCode, 'welcome'),
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue.shade700,
          deviceType: DeviceType.iphone61,
          showDeviceFrame: true,
        ),

        // Features screen for iPhone 6.7"
        ScreenConfig(
          id: 'features_${languageCode}_iphone67',
          screen: FeaturesScreen(languageCode: languageCode),
          title: Text(
            _getTitle(languageCode, 'features'),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          description: Text(
            _getDescription(languageCode, 'features'),
            style: TextStyle(fontSize: 30, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green.shade100,
          deviceType: DeviceType.iphone67,
          showDeviceFrame: true,
        ),

        // Dashboard screen for iPad
        ScreenConfig(
          id: 'dashboard_${languageCode}_ipad',
          screen: DashboardScreen(languageCode: languageCode),
          title: Text(
            _getTitle(languageCode, 'dashboard'),
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          description: Text(
            _getDescription(languageCode, 'dashboard'),
            style: TextStyle(fontSize: 36, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.purple.shade700,
          deviceType: DeviceType.ipad13,
          showDeviceFrame: true,
        ),
      ]);
    }

    // Use the ScreenshotDashboard for easy generation
    return ScreenshotDashboard(screenConfigs: allScreenConfigs);
  }

  // Simple translation function
  String _getTitle(String languageCode, String screen) {
    final translations = {
      'welcome': {
        'en': 'Welcome to Our App',
        'es': 'Bienvenido a Nuestra App',
        'fr': 'Bienvenue dans Notre App',
        'de': 'Willkommen in Unserer App',
        'ja': '私たちのアプリへようこそ',
      },
      'features': {
        'en': 'Amazing Features',
        'es': 'Características Increíbles',
        'fr': 'Fonctionnalités Incroyables',
        'de': 'Erstaunliche Funktionen',
        'ja': '素晴らしい機能',
      },
      'dashboard': {
        'en': 'Your Dashboard',
        'es': 'Tu Panel de Control',
        'fr': 'Votre Tableau de Bord',
        'de': 'Ihr Dashboard',
        'ja': 'あなたのダッシュボード',
      },
    };

    return translations[screen]?[languageCode] ?? translations[screen]?['en'] ?? '';
  }

  String _getDescription(String languageCode, String screen) {
    final translations = {
      'welcome': {
        'en': 'Experience productivity like never before',
        'es': 'Experimenta la productividad como nunca antes',
        'fr': 'Découvrez la productivité comme jamais',
        'de': 'Erleben Sie Produktivität wie nie zuvor',
        'ja': 'これまでにない生産性を体験',
      },
      'features': {
        'en': 'Discover what makes our app special',
        'es': 'Descubre lo que hace especial a nuestra app',
        'fr': 'Découvrez ce qui rend notre app spéciale',
        'de': 'Entdecken Sie, was unsere App besonders macht',
        'ja': 'このアプリの特別な点を発見',
      },
      'dashboard': {
        'en': 'All your data in one place',
        'es': 'Todos tus datos en un lugar',
        'fr': 'Toutes vos données au même endroit',
        'de': 'Alle Ihre Daten an einem Ort',
        'ja': 'すべてのデータを一箇所に',
      },
    };

    return translations[screen]?[languageCode] ?? translations[screen]?['en'] ?? '';
  }
}

// Localized screen widgets
class WelcomeScreen extends StatelessWidget {
  final String languageCode;

  const WelcomeScreen({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
            Icon(Icons.star, size: 80, color: Colors.white),
            SizedBox(height: 30),
            Text(
              _getWelcomeText(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getWelcomeSubtext(),
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWelcomeText() {
    switch (languageCode) {
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

  String _getWelcomeSubtext() {
    switch (languageCode) {
      case 'es':
        return 'Prepárate para algo increíble';
      case 'fr':
        return 'Préparez-vous à quelque chose d\'incroyable';
      case 'de':
        return 'Bereiten Sie sich auf etwas Erstaunliches vor';
      case 'ja':
        return '素晴らしいことの準備をしてください';
      default:
        return 'Get ready for something amazing';
    }
  }
}

class FeaturesScreen extends StatelessWidget {
  final String languageCode;

  const FeaturesScreen({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                _getFeaturesTitle(),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 40),
              Expanded(child: ListView(children: _getFeatureItems())),
            ],
          ),
        ),
      ),
    );
  }

  String _getFeaturesTitle() {
    switch (languageCode) {
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

  List<Widget> _getFeatureItems() {
    final features = _getLocalizedFeatures();
    return features
        .map(
          (feature) => Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF00B894).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(feature['icon'], color: Color(0xFF00B894), size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(feature['subtitle'], style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _getLocalizedFeatures() {
    switch (languageCode) {
      case 'es':
        return [
          {'icon': Icons.speed, 'title': 'Velocidad', 'subtitle': 'Súper rápido y optimizado'},
          {'icon': Icons.security, 'title': 'Seguridad', 'subtitle': 'Protección completa de datos'},
          {'icon': Icons.cloud_sync, 'title': 'Sincronización', 'subtitle': 'En todos tus dispositivos'},
        ];
      case 'fr':
        return [
          {'icon': Icons.speed, 'title': 'Vitesse', 'subtitle': 'Ultra rapide et optimisé'},
          {'icon': Icons.security, 'title': 'Sécurité', 'subtitle': 'Protection complète des données'},
          {'icon': Icons.cloud_sync, 'title': 'Synchronisation', 'subtitle': 'Sur tous vos appareils'},
        ];
      case 'de':
        return [
          {'icon': Icons.speed, 'title': 'Geschwindigkeit', 'subtitle': 'Ultraschnell und optimiert'},
          {'icon': Icons.security, 'title': 'Sicherheit', 'subtitle': 'Vollständiger Datenschutz'},
          {'icon': Icons.cloud_sync, 'title': 'Synchronisation', 'subtitle': 'Auf allen Geräten'},
        ];
      case 'ja':
        return [
          {'icon': Icons.speed, 'title': 'スピード', 'subtitle': '超高速で最適化済み'},
          {'icon': Icons.security, 'title': 'セキュリティ', 'subtitle': '完全なデータ保護'},
          {'icon': Icons.cloud_sync, 'title': '同期', 'subtitle': 'すべてのデバイスで'},
        ];
      default:
        return [
          {'icon': Icons.speed, 'title': 'Speed', 'subtitle': 'Lightning fast and optimized'},
          {'icon': Icons.security, 'title': 'Security', 'subtitle': 'Complete data protection'},
          {'icon': Icons.cloud_sync, 'title': 'Sync', 'subtitle': 'Across all your devices'},
        ];
    }
  }
}

class DashboardScreen extends StatelessWidget {
  final String languageCode;

  const DashboardScreen({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getDashboardTitle(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFE9F1B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.notifications, color: Color(0xFFFE9F1B)),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: _getDashboardCards(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDashboardTitle() {
    switch (languageCode) {
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

  List<Widget> _getDashboardCards() {
    final cards = _getLocalizedCards();
    return cards
        .map(
          (card) => Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: card['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: card['color'].withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(card['icon'], size: 32, color: card['color']),
                SizedBox(height: 12),
                Text(
                  card['value'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: card['color']),
                ),
                SizedBox(height: 4),
                Text(
                  card['title'],
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _getLocalizedCards() {
    switch (languageCode) {
      case 'es':
        return [
          {'title': 'Tareas', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Proyectos', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Mensajes', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Datos', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'fr':
        return [
          {'title': 'Tâches', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projets', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Messages', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Données', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'de':
        return [
          {'title': 'Aufgaben', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projekte', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Nachrichten', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Daten', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      case 'ja':
        return [
          {'title': 'タスク', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'プロジェクト', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'メッセージ', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'データ', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
      default:
        return [
          {'title': 'Tasks', 'value': '24', 'icon': Icons.check_circle, 'color': Colors.green},
          {'title': 'Projects', 'value': '8', 'icon': Icons.folder, 'color': Colors.blue},
          {'title': 'Messages', 'value': '12', 'icon': Icons.message, 'color': Colors.purple},
          {'title': 'Data', 'value': '1.2k', 'icon': Icons.analytics, 'color': Colors.orange},
        ];
    }
  }
}
