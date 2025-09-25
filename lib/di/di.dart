import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:offline_first/di/di.config.dart';
import 'package:offline_first/di/locator.dart';


@InjectableInit(
  initializerName: r'$configureDependencies',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  $configureDependencies(locator);
}
