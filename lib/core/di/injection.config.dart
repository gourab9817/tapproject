// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/bond_detail/data/repositories/bond_detail_repository_impl.dart'
    as _i259;
import '../../features/bond_detail/domain/repositories/bond_detail_repository.dart'
    as _i994;
import '../../features/bond_detail/presentation/bloc/bond_detail_bloc.dart'
    as _i249;
import '../../features/bonds_list/data/repositories/bonds_repository_impl.dart'
    as _i533;
import '../../features/bonds_list/domain/repositories/bonds_repository.dart'
    as _i671;
import '../../features/bonds_list/presentation/bloc/bonds_list_bloc.dart'
    as _i309;
import '../network/dio_client.dart' as _i667;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
  gh.lazySingleton<_i671.BondsRepository>(
    () => _i533.BondsRepositoryImpl(gh<_i667.DioClient>()),
  );
  gh.lazySingleton<_i994.BondDetailRepository>(
    () => _i259.BondDetailRepositoryImpl(gh<_i667.DioClient>()),
  );
  gh.factory<_i309.BondsListBloc>(
    () => _i309.BondsListBloc(gh<_i671.BondsRepository>()),
  );
  gh.factory<_i249.BondDetailBloc>(
    () => _i249.BondDetailBloc(gh<_i994.BondDetailRepository>()),
  );
  return getIt;
}
