import 'package:freezed_annotation/freezed_annotation.dart';

part 'bonds_list_event.freezed.dart';

@freezed
class BondsListEvent with _$BondsListEvent {
  const factory BondsListEvent.loadBonds() = LoadBonds;
  const factory BondsListEvent.searchBonds(String query) = SearchBonds;
  const factory BondsListEvent.clearSearch() = ClearSearch;
  const factory BondsListEvent.refreshBonds() = RefreshBonds;
}
