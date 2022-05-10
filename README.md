# Bosun

## A library for parsing CLI input and structuring CLI commands

[![pub version](https://img.shields.io/pub/v/bosun)](https://img.shields.io/pub/v/bosun)
[![codecov](https://codecov.io/gh/PyreStudios/bosun/branch/main/graph/badge.svg?token=CAK5MR60ZI)](https://codecov.io/gh/PyreStudios/bosun)
[![points](https://img.shields.io/pub/points/bosun)](https://img.shields.io/pub/points/bosun)
[![likes](https://img.shields.io/pub/points/bosun)](https://img.shields.io/pub/points/bosun)


## Features

- Structure CLI commands in a nice, uniform fashion.
- Parse args and flag information from a command tree.
- Auto generate meaningful output when nonsensical commands are ran.
- [EVENTUALLY] meaningful feature suggestions from **you**!

## Getting started

Add Bosun to your dependencies. See example (or usage below) for more information. Additional information coming soon.

## Usage

Bosun is simple to use! You'll leverage Bosun's Command class to structure your own commands. Additionally, you'll new up **one** BosunCommand and pass arguments to it. This is usually done directly in your main method, but doesnt have to be.

```dart
import 'package:bosun/bosun.dart';

class AppCmd extends Command {
  AppCmd() : super(command: 'app', description: 'run as an app shell');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    print("in the app command callback");
  }
}

class RunCmd extends Command {
  RunCmd()
      : super(
            command: 'run',
            description: 'Run a command in a shell',
            subcommands: [AppCmd()]);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    print("in the run command callback");
  }
}

void main(List<String> args) {
  execute(BosunCommand('donker', subcommands: [RunCmd()]), args);
}

```
