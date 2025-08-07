import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/bond_detail_entity.dart';
import '../../domain/repositories/bond_detail_repository.dart';
import '../models/bond_detail_model.dart';

@LazySingleton(as: BondDetailRepository)
class BondDetailRepositoryImpl implements BondDetailRepository {
  final DioClient _dioClient;

  BondDetailRepositoryImpl(this._dioClient);

  // Soft cache per ISIN
  final Map<String, _CachedDetail> _detailCache = {};
  final Duration _ttl = const Duration(seconds: 60);

  @override
  Future<Either<Failure, BondDetailEntity>> getBondDetail(String isin, {bool forceRefresh = false}) async {
    try {
      final cached = _detailCache[isin];
      if (!forceRefresh && cached != null && DateTime.now().isBefore(cached.expiresAt)) {
        return Right(cached.entity);
      }

      final response = await _dioClient.get<Map<String, dynamic>>(
        AppConstants.bondDetailUrl,
        queryParameters: {'isin': isin},
        forceRefresh: forceRefresh,
      );

      if (response.data != null) {
        final bondDetail = BondDetailModel.fromJson(response.data!);
        final entity = bondDetail.toEntity();
        _detailCache[isin] = _CachedDetail(entity, DateTime.now().add(_ttl));
        return Right(entity);
      } else {
        // Fallback to last cached detail if present
        if (cached != null) return Right(cached.entity);
        return const Left(ServerFailure(message: 'No bond detail data received from server'));
      }
    } on DioException catch (e) {
      // Fallback on network error
      final cached = _detailCache[isin];
      if (cached != null) return Right(cached.entity);
      return Left(_handleDioError(e));
    } catch (e) {
      final cached = _detailCache[isin];
      if (cached != null) return Right(cached.entity);
      return Left(UnknownFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
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

class _CachedDetail {
  final BondDetailEntity entity;
  final DateTime expiresAt;
  _CachedDetail(this.entity, this.expiresAt);
}
