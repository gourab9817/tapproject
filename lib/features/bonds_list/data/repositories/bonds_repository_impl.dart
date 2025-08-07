import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/bond_entity.dart';
import '../../domain/repositories/bonds_repository.dart';
import '../models/bond_model.dart';

@LazySingleton(as: BondsRepository)
class BondsRepositoryImpl implements BondsRepository {
  final DioClient _dioClient;
  BondsRepositoryImpl(this._dioClient);

  // Soft cache
  List<BondEntity>? _cachedBonds;
  DateTime? _bondsExpiresAt;
  final Duration _ttl = const Duration(seconds: 60);

  @override
  Future<Either<Failure, List<BondEntity>>> getBonds({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && _cachedBonds != null && _bondsExpiresAt != null && DateTime.now().isBefore(_bondsExpiresAt!)) {
        return Right(_cachedBonds!);
      }

      final response = await _dioClient.get<dynamic>(
        AppConstants.bondsListUrl,
        forceRefresh: forceRefresh,
      );

      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final bondsResponse = BondsListResponse.fromJson(responseData);
          final bonds = bondsResponse.data.map((model) => model.toEntity()).toList();
          _cachedBonds = bonds;
          _bondsExpiresAt = DateTime.now().add(_ttl);
          return Right(bonds);
        } else {
          return const Left(ServerFailure(message: 'Invalid response format'));
        }
      } else {
        return const Left(ServerFailure(message: 'No data received from server'));
      }
    } on DioException catch (e) {
      // Fallback to last cache on error
      if (_cachedBonds != null) return Right(_cachedBonds!);
      return Left(_handleDioError(e));
    } catch (e) {
      if (_cachedBonds != null) return Right(_cachedBonds!);
      return Left(UnknownFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Optional helper to prefetch details (no-op here; implement if needed)
  Future<void> prefetchTopDetails(int count) async {
    // This repo does not own detail API; suggest calling BondDetailRepository in Bloc after list load.
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Network connection failed. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data?.toString() ?? 'Server error occurred';
        return ServerFailure(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled');
      default:
        return UnknownFailure(message: 'An unknown network error occurred: ${error.message}');
    }
  }
}
