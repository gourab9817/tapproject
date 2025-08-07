import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bond_detail_entity.dart';

abstract class BondDetailRepository {
  Future<Either<Failure, BondDetailEntity>> getBondDetail(String isin);
}
