import 'package:get_it/get_it.dart';

class DI {
  DI._();

  static T resolve<T extends Object>() => GetIt.instance<T>();

  static Future<void> initialize() async {}
}
