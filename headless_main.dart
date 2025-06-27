import 'dart:io';
import 'package:flutter/material.dart';
import 'bin/screenshot_cli.dart' as cli;

void main(List<String> args) async {
  // For headless Flutter apps, we need to ensure the binding is initialized
  // but we don't actually need to run a UI
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Run the CLI logic
    await cli.main(args);
    // Exit after CLI completes
    exit(0);
  } catch (error) {
    print('Error: $error');
    exit(1);
  }
}
