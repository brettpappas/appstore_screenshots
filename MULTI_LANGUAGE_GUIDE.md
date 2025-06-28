# Multi-Language Screenshot Generation Guide

This guide explains how to use the `appstore_screenshots` package to generate the same screenshot for multiple languages, which is essential for App Store submissions that support international markets.

## Overview

When publishing apps to international markets, you need localized screenshots for each supported language. This package allows you to:

1. **Generate screenshots for multiple languages automatically**
2. **Use Flutter's localization system** to change app content
3. **Maintain consistent layout and design** across all languages
4. **Batch export all screenshots** in a single ZIP file organized by language

## Quick Start

### 1. Basic Multi-Language Setup

```dart
import 'package:appstore_screenshots/appstore_screenshots.dart';

class MultiLanguageScreenshotExample extends StatefulWidget {
  @override
  State<MultiLanguageScreenshotExample> createState() => _MultiLanguageScreenshotExampleState();
}

class _MultiLanguageScreenshotExampleState extends State<MultiLanguageScreenshotExample> {
  final ScreenshotManager _manager = ScreenshotManager();
  
  // Define supported languages
  final List<Locale> _supportedLocales = [
    Locale('en'), // English
    Locale('es'), // Spanish  
    Locale('fr'), // French
    Locale('de'), // German
    Locale('ja'), // Japanese
  ];

  Future<void> _generateMultiLanguageScreenshots() async {
    List<ScreenConfig> allScreenConfigs = [];
    
    // Generate screen configs for each language
    for (final locale in _supportedLocales) {
      final screenConfigs = _createScreenConfigsForLocale(locale);
      allScreenConfigs.addAll(screenConfigs);
    }

    // Configure and capture
    final config = ScreenshotConfig(
      screens: allScreenConfigs,
      outputDirectory: 'multi_language_screenshots',
      captureDelay: 2000, // Allow time for language switching
    );

    _manager.configure(config);
    
    final zipPath = await _manager.captureAllScreensAsZipWithContext(
      context: context,
      zipFileName: 'app_screenshots_all_languages.zip',
    );
  }
}
```

### 2. Creating Localized Screen Configs

```dart
List<ScreenConfig> _createScreenConfigsForLocale(Locale locale) {
  return [
    ScreenConfig(
      id: 'welcome_${locale.languageCode}_iphone61',
      screen: LocalizedWelcomeScreen(locale: locale),
      title: Text(
        _getLocalizedTitle('Welcome to Amazing App', locale),
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
      ),
      description: Text(
        _getLocalizedDescription('Experience productivity like never before', locale),
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
      backgroundColor: Colors.blue.shade600,
      deviceType: DeviceType.iphone61,
      showDeviceFrame: true,
    ),
    // Add more screen configs for different device types...
  ];
}
```

### 3. Localized Screen Widgets

Create screen widgets that adapt to different locales:

```dart
class LocalizedWelcomeScreen extends StatelessWidget {
  final Locale locale;

  const LocalizedWelcomeScreen({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
              _getWelcomeText(locale),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              _getWelcomeSubtext(locale),
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getWelcomeText(Locale locale) {
    switch (locale.languageCode) {
      case 'es': return '¡Bienvenido!';
      case 'fr': return 'Bienvenue!';
      case 'de': return 'Willkommen!';
      case 'ja': return 'ようこそ！';
      default: return 'Welcome!';
    }
  }

  String _getWelcomeSubtext(Locale locale) {
    switch (locale.languageCode) {
      case 'es': return 'Prepárate para experimentar algo increíble';
      case 'fr': return 'Préparez-vous à vivre quelque chose d\'incroyable';
      case 'de': return 'Bereiten Sie sich darauf vor, etwas Erstaunliches zu erleben';
      case 'ja': return '素晴らしい体験の準備をしてください';
      default: return 'Get ready to experience something amazing';
    }
  }
}
```

## Advanced Approaches

### Option 1: Manual Translation Maps

Use translation maps for simple text content:

```dart
String _getLocalizedText(String key, Locale locale) {
  final translations = {
    'en': {
      'welcome_title': 'Welcome to Amazing App',
      'features_title': 'Amazing Features',
      'dashboard_title': 'Your Dashboard',
    },
    'es': {
      'welcome_title': 'Bienvenido a Amazing App',
      'features_title': 'Características Increíbles', 
      'dashboard_title': 'Tu Panel de Control',
    },
    'fr': {
      'welcome_title': 'Bienvenue dans Amazing App',
      'features_title': 'Fonctionnalités Incroyables',
      'dashboard_title': 'Votre Tableau de Bord',
    },
    // Add more languages...
  };
  
  return translations[locale.languageCode]?[key] ?? key;
}
```

### Option 2: Flutter Intl Integration

For larger apps, integrate with Flutter's official internationalization:

1. **Add dependencies to `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

dev_dependencies:
  flutter_gen: ^5.1.0

flutter:
  generate: true
```

2. **Create `l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

3. **Create ARB files:**

`lib/l10n/app_en.arb`:
```json
{
  "welcomeTitle": "Welcome to Amazing App",
  "featuresTitle": "Amazing Features",
  "dashboardTitle": "Your Dashboard",
  "welcomeSubtitle": "Get ready to experience something amazing"
}
```

`lib/l10n/app_es.arb`:
```json
{
  "welcomeTitle": "Bienvenido a Amazing App",
  "featuresTitle": "Características Increíbles",
  "dashboardTitle": "Tu Panel de Control", 
  "welcomeSubtitle": "Prepárate para experimentar algo increíble"
}
```

4. **Use in your localized screens:**
```dart
class LocalizedWelcomeScreen extends StatelessWidget {
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: locale,
      child: Builder(
        builder: (localizedContext) {
          final l10n = AppLocalizations.of(localizedContext)!;
          return Container(
            child: Column(
              children: [
                Text(l10n.welcomeTitle),
                Text(l10n.welcomeSubtitle),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Option 3: Using ScreenshotDashboard with Locale Context

Use the simplified dashboard approach with locale context:

```dart
class MyMultiLanguageApp extends StatelessWidget {
  final Locale locale;
  
  const MyMultiLanguageApp({required this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [locale],
      home: ScreenshotDashboard(
        screenConfigs: _createLocalizedScreenConfigs(locale),
      ),
    );
  }
}
```

## Best Practices

### 1. Consistent Device Types

Generate the same device types for each language:

```dart
List<DeviceType> getRequiredDeviceTypes() {
  return [
    DeviceType.iphone61,   // iPhone 6.1" (required for App Store)
    DeviceType.iphone67,   // iPhone 6.7" (required for App Store)
    DeviceType.ipad13,     // iPad (if you support iPad)
  ];
}

List<ScreenConfig> _createScreenConfigsForLocale(Locale locale) {
  List<ScreenConfig> configs = [];
  
  for (final deviceType in getRequiredDeviceTypes()) {
    configs.addAll([
      ScreenConfig(
        id: 'welcome_${locale.languageCode}_${deviceType.name}',
        screen: LocalizedWelcomeScreen(locale: locale),
        deviceType: deviceType,
        // ... other config
      ),
      ScreenConfig(
        id: 'features_${locale.languageCode}_${deviceType.name}',
        screen: LocalizedFeaturesScreen(locale: locale),
        deviceType: deviceType,
        // ... other config
      ),
    ]);
  }
  
  return configs;
}
```

### 2. File Organization

The package will organize your screenshots by screen ID. Use a consistent naming convention:

```dart
// This generates files like:
// welcome_en_iphone61.png
// welcome_es_iphone61.png
// welcome_fr_iphone61.png
// features_en_iphone61.png
// features_es_iphone61.png
// etc.

ScreenConfig(
  id: '${screenName}_${locale.languageCode}_${deviceType.name}',
  // ...
)
```

### 3. Text Overflow Handling

Different languages have different text lengths. Handle this in your layouts:

```dart
Text(
  localizedText,
  style: TextStyle(fontSize: 48),
  textAlign: TextAlign.center,
  maxLines: 2, // Allow text wrapping
  overflow: TextOverflow.ellipsis,
)
```

### 4. Progress Tracking

Show progress when generating many screenshots:

```dart
final zipPath = await _manager.captureAllScreensAsZipWithContext(
  context: context,
  zipFileName: 'app_screenshots_all_languages.zip',
  onProgress: (screenId, current, total) {
    print('Capturing $screenId ($current/$total)');
    // Update your UI progress indicator
  },
);
```

## App Store Requirements

### iOS App Store
- **iPhone 6.7"**: 1290 × 2796 pixels (required)
- **iPhone 6.1"**: 1179 × 2556 pixels (required) 
- **iPad 13"**: 2048 × 2732 pixels (if app supports iPad)

### Google Play Store
- **Android**: 1080 × 1920 pixels minimum
- Maximum 8 screenshots per language

### Screenshot Tips
1. **Show your app's key features** in the first 3 screenshots
2. **Use actual app content** rather than marketing graphics
3. **Maintain consistent branding** across all languages
4. **Test text readability** on actual device screens
5. **Consider cultural preferences** for colors and imagery

## Example Output Structure

After generation, your ZIP file will contain:
```
multi_language_screenshots/
├── welcome_en_iphone61.png
├── welcome_en_iphone67.png
├── welcome_en_ipad13.png
├── welcome_es_iphone61.png
├── welcome_es_iphone67.png
├── welcome_es_ipad13.png
├── features_en_iphone61.png
├── features_es_iphone61.png
├── ... (all combinations)
└── dashboard_ja_ipad13.png
```

You can then organize these by language for upload to each App Store locale.

## Common Issues

### Text Cutoff
- Use `maxLines` and `overflow` properties
- Test with longest translations
- Consider reducing font size for certain languages

### Layout Issues
- Use `Flexible` and `Expanded` widgets
- Test different text lengths
- Consider different reading directions (RTL languages)

### Memory Issues
- Generate screenshots in batches if you have many languages
- Use appropriate image compression
- Clear widget tree between captures if needed

## Complete Example

See the `multi_language_screenshots.dart` file in the example folder for a complete working implementation that demonstrates all these concepts.
