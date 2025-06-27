#!/usr/bin/env dart

import 'bin/screenshot_cli.dart' as cli;

/// Simple runner for the headless CLI
Future<void> main(List<String> arguments) async {
  // Just run the CLI main with the arguments
  await cli.main(arguments);
}
