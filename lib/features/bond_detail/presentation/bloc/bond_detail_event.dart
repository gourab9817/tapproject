import 'package:freezed_annotation/freezed_annotation.dart';

part 'bond_detail_event.freezed.dart';

@freezed
class BondDetailEvent with _$BondDetailEvent {
  const factory BondDetailEvent.loadBondDetail(String isin) = LoadBondDetail;
  const factory BondDetailEvent.changeTab(int tabIndex) = ChangeTab;
  const factory BondDetailEvent.refreshBondDetail(String isin) = RefreshBondDetail;
}
