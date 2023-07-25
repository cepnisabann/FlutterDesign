// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:design/di/module.dart' as _i6;
import 'package:design/repo/product_repository.dart' as _i5;
import 'package:design/service/rest_client.dart' as _i4;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i3.Dio>(appModule.dioInstance);
    gh.singleton<_i4.RestClient>(appModule.restClient);
    gh.singleton<_i5.ProductRepository>(
        _i5.ProductRepositoryImpl(gh<_i4.RestClient>()));
    return this;
  }
}

class _$AppModule extends _i6.AppModule {}
