import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future setupDI() {
  return getIt.init();

  // Register all the generated dependencies
}
