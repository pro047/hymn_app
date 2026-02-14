import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

Future<void> main() async {
  final envFile = appEnv == 'prod'
      ? '.env.prod'
      : appEnv == 'stg'
      ? '.env.staging'
      : '.env.local';

  debugPrint('appEnv : $appEnv');

  await dotenv.load(fileName: envFile);
  runApp(const HymnApp());
}
