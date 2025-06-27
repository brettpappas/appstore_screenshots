import 'package:flutter_test/flutter_test.dart';
import 'package:appstore_screenshots/appstore_screenshots.dart';
import 'dart:io';

void main() {
  group('ZIP Functionality Tests', () {
    test('should create ZIP from file paths', () async {
      final manager = ScreenshotManager();

      // Create test directory with files
      final testDir = Directory('test_zip_screenshots');
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }

      // Create some test PNG files
      final testFiles = ['test1.png', 'test2.png'];
      for (final fileName in testFiles) {
        final file = File('test_zip_screenshots/$fileName');
        await file.writeAsBytes([137, 80, 78, 71, 13, 10, 26, 10]); // PNG signature
      }

      // Test createZipFromFiles method
      final zipPath = await manager.createZipFromFiles(
        filePaths: testFiles.map((f) => 'test_zip_screenshots/$f').toList(),
        outputPath: 'test_zip_screenshots',
        zipFileName: 'test_screenshots.zip',
      );

      expect(zipPath, isNotNull);
      if (zipPath != null) {
        final zipFile = File(zipPath);
        expect(await zipFile.exists(), isTrue);
        expect(await zipFile.length(), greaterThan(0));
        print('✅ ZIP file created successfully: $zipPath');
      }

      // Clean up
      if (await testDir.exists()) {
        await testDir.delete(recursive: true);
      }
    });

    test('should create ZIP from directory', () async {
      final manager = ScreenshotManager();

      // Create test directory with files
      final testDir = Directory('test_directory_zip');
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }

      // Create some test PNG files
      final testFiles = ['screen1.png', 'screen2.png', 'screen3.png'];
      for (final fileName in testFiles) {
        final file = File('test_directory_zip/$fileName');
        await file.writeAsBytes([137, 80, 78, 71, 13, 10, 26, 10]); // PNG signature
      }

      // Test createZipFromDirectory method
      final zipPath = await manager.createZipFromDirectory(
        sourceDirectory: 'test_directory_zip',
        zipFileName: 'directory_screenshots.zip',
      );

      expect(zipPath, isNotNull);
      if (zipPath != null) {
        final zipFile = File(zipPath);
        expect(await zipFile.exists(), isTrue);
        expect(await zipFile.length(), greaterThan(0));
        print('✅ ZIP from directory created successfully: $zipPath');
      }

      // Clean up
      if (await testDir.exists()) {
        await testDir.delete(recursive: true);
      }
    });

    test('should handle empty file list gracefully', () async {
      final manager = ScreenshotManager();

      final zipPath = await manager.createZipFromFiles(filePaths: [], zipFileName: 'empty_test.zip');

      expect(zipPath, isNull);
    });

    test('should handle non-existent files gracefully', () async {
      final manager = ScreenshotManager();

      final zipPath = await manager.createZipFromFiles(
        filePaths: ['non_existent_file.png'],
        zipFileName: 'missing_files_test.zip',
      );

      expect(zipPath, isNotNull); // Should still create ZIP even if some files are missing
    });
  });
}
