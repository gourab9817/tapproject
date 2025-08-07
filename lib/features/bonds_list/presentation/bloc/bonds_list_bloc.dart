import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/bonds_repository.dart';
import '../../domain/entities/bond_entity.dart';
import 'bonds_list_event.dart';
import 'bonds_list_state.dart';

@injectable
class BondsListBloc extends Bloc<BondsListEvent, BondsListState> {
  final BondsRepository _bondsRepository;

  BondsListBloc(this._bondsRepository) : super(const BondsListInitial()) {
    on<LoadBonds>(_onLoadBonds);
    on<SearchBonds>(_onSearchBonds);
    on<ClearSearch>(_onClearSearch);
    on<RefreshBonds>(_onRefreshBonds);
  }

  Future<void> _onLoadBonds(LoadBonds event, Emitter<BondsListState> emit) async {
    emit(const BondsListLoading());

    final result = await _bondsRepository.getBonds();

    result.fold(
      (failure) => emit(BondsListError(failure: failure)),
      (bonds) => emit(BondsListLoaded(bonds: bonds)),
    );
  }

  void _onSearchBonds(SearchBonds event, Emitter<BondsListState> emit) {
    final query = event.query.trim();
    
    // Get current state
    final currentState = state;
    if (currentState is BondsListLoaded) {
      // Perform local search immediately
      if (query.isEmpty) {
        // Show all bonds when query is empty
        emit(currentState.copyWith(
          filteredBonds: [],
          searchQuery: '',
          isSearching: false,
        ));
      } else {
        // Perform local filtering
        final filteredBonds = _performLocalSearch(currentState.bonds, query);
        
        emit(currentState.copyWith(
          filteredBonds: filteredBonds,
          searchQuery: query,
          isSearching: false,
        ));
      }
    } else {
      // If not in loaded state, load bonds first
      add(const LoadBonds());
    }
  }

  List<BondEntity> _performLocalSearch(List<BondEntity> bonds, String query) {
    final queryLower = query.toLowerCase();
    
    return bonds.where((bond) {
      // Search in company name
      final companyMatch = bond.companyName.toLowerCase().contains(queryLower);
      
      // Search in ISIN
      final isinMatch = bond.isin.toLowerCase().contains(queryLower);
      
      // Search in rating
      final ratingMatch = bond.rating.toLowerCase().contains(queryLower);
      
      // Search in tags
      final tagsMatch = bond.tags.any((tag) => tag.toLowerCase().contains(queryLower));
      
      return companyMatch || isinMatch || ratingMatch || tagsMatch;
    }).toList();
  }

  void _onClearSearch(ClearSearch event, Emitter<BondsListState> emit) {
    final currentState = state;
    if (currentState is BondsListLoaded) {
      emit(currentState.copyWith(
        filteredBonds: [],
        searchQuery: '',
        isSearching: false,
      ));
    }
  }

  Future<void> _onRefreshBonds(RefreshBonds event, Emitter<BondsListState> emit) async {
    // Don't show loading for refresh, just update data
    final result = await _bondsRepository.getBonds();

    result.fold(
      (failure) => emit(BondsListError(failure: failure)),
      (bonds) => emit(BondsListLoaded(bonds: bonds)),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
