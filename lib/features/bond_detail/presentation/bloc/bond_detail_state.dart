import 'package:equatable/equatable.dart';
import '../../domain/entities/bond_detail_entity.dart';
import '../../../../core/error/failures.dart';

abstract class BondDetailState extends Equatable {
  const BondDetailState();
  
  @override
  List<Object?> get props => [];
}

class BondDetailInitial extends BondDetailState {
  const BondDetailInitial();
}

class BondDetailLoading extends BondDetailState {
  const BondDetailLoading();
}

class BondDetailLoaded extends BondDetailState {
  final BondDetailEntity bondDetail;
  final int currentTabIndex;
  
  const BondDetailLoaded({
    required this.bondDetail,
    this.currentTabIndex = 0,
  });
  
  @override
  List<Object?> get props => [bondDetail, currentTabIndex];
  
  BondDetailLoaded copyWith({
    BondDetailEntity? bondDetail,
    int? currentTabIndex,
  }) {
    return BondDetailLoaded(
      bondDetail: bondDetail ?? this.bondDetail,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

class BondDetailError extends BondDetailState {
  final Failure failure;
  final int currentTabIndex;
  
  const BondDetailError({
    required this.failure,
    this.currentTabIndex = 0,
  });
  
  @override
  List<Object?> get props => [failure, currentTabIndex];
  
  BondDetailError copyWith({
    Failure? failure,
    int? currentTabIndex,
  }) {
    return BondDetailError(
      failure: failure ?? this.failure,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}