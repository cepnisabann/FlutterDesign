// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:design/di/module.dart' as _i15;
import 'package:design/pages/viewmodels/detailspage_vm.dart' as _i12;
import 'package:design/pages/viewmodels/favoritespage_vm.dart' as _i13;
import 'package:design/pages/viewmodels/homepage_vm.dart' as _i14;
import 'package:design/pages/viewmodels/loginpage_vm.dart' as _i6;
import 'package:design/pages/viewmodels/profilepage_vm.dart' as _i7;
import 'package:design/pages/viewmodels/storepage_vm.dart' as _i11;
import 'package:design/repo/favorite_repository.dart' as _i9;
import 'package:design/repo/product_repository.dart' as _i10;
import 'package:design/service/likedproducts.dart' as _i5;
import 'package:design/service/rest_client.dart' as _i8;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i3.Dio>(appModule.dioInstance);
    await gh.singletonAsync<_i4.GetStorage>(
      () => appModule.initializeGetStorage,
      preResolve: true,
    );
    gh.singleton<_i5.LikedProducts>(_i5.LikedProducts(gh<_i4.GetStorage>()));
    gh.factory<_i6.LoginPageViewModel>(() => _i6.LoginPageViewModel());
    gh.factory<_i7.ProfilePageViewModel>(() => _i7.ProfilePageViewModel());
    gh.singleton<_i8.RestClient>(appModule.restClient);
    gh.singleton<_i9.FavoriteRepository>(
        _i9.FavoriteRepositoryImpl(gh<_i5.LikedProducts>()));
    gh.singleton<_i10.ProductRepository>(_i10.ProductRepositoryImpl(
      gh<_i8.RestClient>(),
      gh<_i5.LikedProducts>(),
    ));
    gh.factory<_i11.StorePageViewModel>(() => _i11.StorePageViewModel(
          gh<_i10.ProductRepository>(),
          gh<_i9.FavoriteRepository>(),
        ));
    gh.factory<_i12.DetailsViewModel>(
        () => _i12.DetailsViewModel(gh<_i10.ProductRepository>()));
    gh.factory<_i13.FavoritesViewModel>(() => _i13.FavoritesViewModel(
          gh<_i10.ProductRepository>(),
          gh<_i9.FavoriteRepository>(),
        ));
    gh.factory<_i14.HomeViewModel>(() => _i14.HomeViewModel(
          gh<_i10.ProductRepository>(),
          gh<_i9.FavoriteRepository>(),
        ));
    return this;
  }
}

class _$AppModule extends _i15.AppModule {}
