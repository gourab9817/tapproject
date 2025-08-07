import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/bond_detail_repository.dart';
import 'bond_detail_event.dart';
import 'bond_detail_state.dart';

@injectable
class BondDetailBloc extends Bloc<BondDetailEvent, BondDetailState> {
  final BondDetailRepository _bondDetailRepository;

  BondDetailBloc(this._bondDetailRepository) : super(const BondDetailInitial()) {
    on<LoadBondDetail>(_onLoadBondDetail);
    on<ChangeTab>(_onChangeTab);
    on<RefreshBondDetail>(_onRefreshBondDetail);
  }

  Future<void> _onLoadBondDetail(LoadBondDetail event, Emitter<BondDetailState> emit) async {
    emit(const BondDetailLoading());

    final result = await _bondDetailRepository.getBondDetail(event.isin);

    result.fold(
      (failure) => emit(BondDetailError(failure: failure)),
      (bondDetail) => emit(BondDetailLoaded(bondDetail: bondDetail)),
    );
  }

  void _onChangeTab(ChangeTab event, Emitter<BondDetailState> emit) {
    final currentState = state;
    if (currentState is BondDetailLoaded) {
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    } else if (currentState is BondDetailError) {
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  Future<void> _onRefreshBondDetail(RefreshBondDetail event, Emitter<BondDetailState> emit) async {
    final currentState = state;
    int currentTabIndex = 0;
    
    if (currentState is BondDetailLoaded) {
      currentTabIndex = currentState.currentTabIndex;
    } else if (currentState is BondDetailError) {
      currentTabIndex = currentState.currentTabIndex;
    }

    final result = await _bondDetailRepository.getBondDetail(event.isin);

    result.fold(
      (failure) => emit(BondDetailError(
        failure: failure,
        currentTabIndex: currentTabIndex,
      )),
      (bondDetail) => emit(BondDetailLoaded(
        bondDetail: bondDetail,
        currentTabIndex: currentTabIndex,
      )),
    );
  }
}
