import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bond_entity.dart';

abstract class BondsRepository {
  Future<Either<Failure, List<BondEntity>>> getBonds();
}
