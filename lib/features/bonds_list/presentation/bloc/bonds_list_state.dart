import 'package:equatable/equatable.dart';
import '../../domain/entities/bond_entity.dart';
import '../../../../core/error/failures.dart';

abstract class BondsListState extends Equatable {
  const BondsListState();
  
  @override
  List<Object?> get props => [];
}

class BondsListInitial extends BondsListState {
  const BondsListInitial();
}

class BondsListLoading extends BondsListState {
  const BondsListLoading();
}

class BondsListLoaded extends BondsListState {
  final List<BondEntity> bonds;
  final List<BondEntity> filteredBonds;
  final String searchQuery;
  final bool isSearching;
  
  const BondsListLoaded({
    required this.bonds,
    this.filteredBonds = const [],
    this.searchQuery = '',
    this.isSearching = false,
  });
  
  @override
  List<Object?> get props => [bonds, filteredBonds, searchQuery, isSearching];
  
  BondsListLoaded copyWith({
    List<BondEntity>? bonds,
    List<BondEntity>? filteredBonds,
    String? searchQuery,
    bool? isSearching,
  }) {
    return BondsListLoaded(
      bonds: bonds ?? this.bonds,
      filteredBonds: filteredBonds ?? this.filteredBonds,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class BondsListError extends BondsListState {
  final Failure failure;
  final List<BondEntity> bonds;
  
  const BondsListError({
    required this.failure,
    this.bonds = const [],
  });
  
  @override
  List<Object?> get props => [failure, bonds];
  
  BondsListError copyWith({
    Failure? failure,
    List<BondEntity>? bonds,
  }) {
    return BondsListError(
      failure: failure ?? this.failure,
      bonds: bonds ?? this.bonds,
    );
  }
}