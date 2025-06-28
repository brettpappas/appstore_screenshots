import 'package:flutter/material.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';

/// Simple example showing how to use the new ScreenshotDashboard widget
class SimpleDashboardExample extends StatelessWidget {
  const SimpleDashboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your screen configurations
    final screenConfigs = [
      ScreenConfig(
        id: 'welcome_iphone61',
        screen: _buildWelcomeScreen(),
        title: const Text(
          'Welcome to My App',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        description: const Text(
          'Experience amazing productivity.',
          style: TextStyle(fontSize: 30, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        deviceType: DeviceType.iphone61,
        showDeviceFrame: true,
      ),
      ScreenConfig(
        id: 'features_iphone67',
        screen: _buildFeaturesScreen(),
        title: const Text(
          'Amazing Features',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        description: const Text(
          'Discover what makes our app special.',
          style: TextStyle(fontSize: 30, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        deviceType: DeviceType.iphone67,
        showDeviceFrame: true,
      ),
      ScreenConfig(
        id: 'dashboard_ipad',
        screen: _buildDashboardScreen(),
        title: const Text(
          'Beautiful Dashboard',
          style: TextStyle(fontSize: 72, fontWeight: FontWeight.w700, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        description: const Text(
          'Manage everything from one place.',
          style: TextStyle(fontSize: 40, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.orange,
        deviceType: DeviceType.ipad13,
        showDeviceFrame: true,
      ),
    ];

    // Use the ScreenshotDashboard widget - no helper functions needed!
    return ScreenshotDashboard(
      screenConfigs: screenConfigs,
      title: 'My App Screenshots',
      outputDirectory: 'my_app_screenshots',
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
}
