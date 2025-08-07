// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bonds_list_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BondsListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BondsListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BondsListEvent()';
}


}

/// @nodoc
class $BondsListEventCopyWith<$Res>  {
$BondsListEventCopyWith(BondsListEvent _, $Res Function(BondsListEvent) __);
}


/// Adds pattern-matching-related methods to [BondsListEvent].
extension BondsListEventPatterns on BondsListEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadBonds value)?  loadBonds,TResult Function( SearchBonds value)?  searchBonds,TResult Function( ClearSearch value)?  clearSearch,TResult Function( RefreshBonds value)?  refreshBonds,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadBonds() when loadBonds != null:
return loadBonds(_that);case SearchBonds() when searchBonds != null:
return searchBonds(_that);case ClearSearch() when clearSearch != null:
return clearSearch(_that);case RefreshBonds() when refreshBonds != null:
return refreshBonds(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadBonds value)  loadBonds,required TResult Function( SearchBonds value)  searchBonds,required TResult Function( ClearSearch value)  clearSearch,required TResult Function( RefreshBonds value)  refreshBonds,}){
final _that = this;
switch (_that) {
case LoadBonds():
return loadBonds(_that);case SearchBonds():
return searchBonds(_that);case ClearSearch():
return clearSearch(_that);case RefreshBonds():
return refreshBonds(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadBonds value)?  loadBonds,TResult? Function( SearchBonds value)?  searchBonds,TResult? Function( ClearSearch value)?  clearSearch,TResult? Function( RefreshBonds value)?  refreshBonds,}){
final _that = this;
switch (_that) {
case LoadBonds() when loadBonds != null:
return loadBonds(_that);case SearchBonds() when searchBonds != null:
return searchBonds(_that);case ClearSearch() when clearSearch != null:
return clearSearch(_that);case RefreshBonds() when refreshBonds != null:
return refreshBonds(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadBonds,TResult Function( String query)?  searchBonds,TResult Function()?  clearSearch,TResult Function()?  refreshBonds,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadBonds() when loadBonds != null:
return loadBonds();case SearchBonds() when searchBonds != null:
return searchBonds(_that.query);case ClearSearch() when clearSearch != null:
return clearSearch();case RefreshBonds() when refreshBonds != null:
return refreshBonds();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadBonds,required TResult Function( String query)  searchBonds,required TResult Function()  clearSearch,required TResult Function()  refreshBonds,}) {final _that = this;
switch (_that) {
case LoadBonds():
return loadBonds();case SearchBonds():
return searchBonds(_that.query);case ClearSearch():
return clearSearch();case RefreshBonds():
return refreshBonds();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadBonds,TResult? Function( String query)?  searchBonds,TResult? Function()?  clearSearch,TResult? Function()?  refreshBonds,}) {final _that = this;
switch (_that) {
case LoadBonds() when loadBonds != null:
return loadBonds();case SearchBonds() when searchBonds != null:
return searchBonds(_that.query);case ClearSearch() when clearSearch != null:
return clearSearch();case RefreshBonds() when refreshBonds != null:
return refreshBonds();case _:
  return null;

}
}

}

/// @nodoc


class LoadBonds implements BondsListEvent {
  const LoadBonds();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadBonds);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BondsListEvent.loadBonds()';
}


}




/// @nodoc


class SearchBonds implements BondsListEvent {
  const SearchBonds(this.query);
  

 final  String query;

/// Create a copy of BondsListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchBondsCopyWith<SearchBonds> get copyWith => _$SearchBondsCopyWithImpl<SearchBonds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchBonds&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'BondsListEvent.searchBonds(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchBondsCopyWith<$Res> implements $BondsListEventCopyWith<$Res> {
  factory $SearchBondsCopyWith(SearchBonds value, $Res Function(SearchBonds) _then) = _$SearchBondsCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchBondsCopyWithImpl<$Res>
    implements $SearchBondsCopyWith<$Res> {
  _$SearchBondsCopyWithImpl(this._self, this._then);

  final SearchBonds _self;
  final $Res Function(SearchBonds) _then;

/// Create a copy of BondsListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchBonds(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearSearch implements BondsListEvent {
  const ClearSearch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearSearch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BondsListEvent.clearSearch()';
}


}




/// @nodoc


class RefreshBonds implements BondsListEvent {
  const RefreshBonds();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshBonds);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BondsListEvent.refreshBonds()';
}


}




// dart format on
