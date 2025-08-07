// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bond_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BondDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BondDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BondDetailEvent()';
}


}

/// @nodoc
class $BondDetailEventCopyWith<$Res>  {
$BondDetailEventCopyWith(BondDetailEvent _, $Res Function(BondDetailEvent) __);
}


/// Adds pattern-matching-related methods to [BondDetailEvent].
extension BondDetailEventPatterns on BondDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadBondDetail value)?  loadBondDetail,TResult Function( ChangeTab value)?  changeTab,TResult Function( RefreshBondDetail value)?  refreshBondDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadBondDetail() when loadBondDetail != null:
return loadBondDetail(_that);case ChangeTab() when changeTab != null:
return changeTab(_that);case RefreshBondDetail() when refreshBondDetail != null:
return refreshBondDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadBondDetail value)  loadBondDetail,required TResult Function( ChangeTab value)  changeTab,required TResult Function( RefreshBondDetail value)  refreshBondDetail,}){
final _that = this;
switch (_that) {
case LoadBondDetail():
return loadBondDetail(_that);case ChangeTab():
return changeTab(_that);case RefreshBondDetail():
return refreshBondDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadBondDetail value)?  loadBondDetail,TResult? Function( ChangeTab value)?  changeTab,TResult? Function( RefreshBondDetail value)?  refreshBondDetail,}){
final _that = this;
switch (_that) {
case LoadBondDetail() when loadBondDetail != null:
return loadBondDetail(_that);case ChangeTab() when changeTab != null:
return changeTab(_that);case RefreshBondDetail() when refreshBondDetail != null:
return refreshBondDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String isin)?  loadBondDetail,TResult Function( int tabIndex)?  changeTab,TResult Function( String isin)?  refreshBondDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadBondDetail() when loadBondDetail != null:
return loadBondDetail(_that.isin);case ChangeTab() when changeTab != null:
return changeTab(_that.tabIndex);case RefreshBondDetail() when refreshBondDetail != null:
return refreshBondDetail(_that.isin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String isin)  loadBondDetail,required TResult Function( int tabIndex)  changeTab,required TResult Function( String isin)  refreshBondDetail,}) {final _that = this;
switch (_that) {
case LoadBondDetail():
return loadBondDetail(_that.isin);case ChangeTab():
return changeTab(_that.tabIndex);case RefreshBondDetail():
return refreshBondDetail(_that.isin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String isin)?  loadBondDetail,TResult? Function( int tabIndex)?  changeTab,TResult? Function( String isin)?  refreshBondDetail,}) {final _that = this;
switch (_that) {
case LoadBondDetail() when loadBondDetail != null:
return loadBondDetail(_that.isin);case ChangeTab() when changeTab != null:
return changeTab(_that.tabIndex);case RefreshBondDetail() when refreshBondDetail != null:
return refreshBondDetail(_that.isin);case _:
  return null;

}
}

}

/// @nodoc


class LoadBondDetail implements BondDetailEvent {
  const LoadBondDetail(this.isin);
  

 final  String isin;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadBondDetailCopyWith<LoadBondDetail> get copyWith => _$LoadBondDetailCopyWithImpl<LoadBondDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadBondDetail&&(identical(other.isin, isin) || other.isin == isin));
}


@override
int get hashCode => Object.hash(runtimeType,isin);

@override
String toString() {
  return 'BondDetailEvent.loadBondDetail(isin: $isin)';
}


}

/// @nodoc
abstract mixin class $LoadBondDetailCopyWith<$Res> implements $BondDetailEventCopyWith<$Res> {
  factory $LoadBondDetailCopyWith(LoadBondDetail value, $Res Function(LoadBondDetail) _then) = _$LoadBondDetailCopyWithImpl;
@useResult
$Res call({
 String isin
});




}
/// @nodoc
class _$LoadBondDetailCopyWithImpl<$Res>
    implements $LoadBondDetailCopyWith<$Res> {
  _$LoadBondDetailCopyWithImpl(this._self, this._then);

  final LoadBondDetail _self;
  final $Res Function(LoadBondDetail) _then;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isin = null,}) {
  return _then(LoadBondDetail(
null == isin ? _self.isin : isin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangeTab implements BondDetailEvent {
  const ChangeTab(this.tabIndex);
  

 final  int tabIndex;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeTabCopyWith<ChangeTab> get copyWith => _$ChangeTabCopyWithImpl<ChangeTab>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeTab&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tabIndex);

@override
String toString() {
  return 'BondDetailEvent.changeTab(tabIndex: $tabIndex)';
}


}

/// @nodoc
abstract mixin class $ChangeTabCopyWith<$Res> implements $BondDetailEventCopyWith<$Res> {
  factory $ChangeTabCopyWith(ChangeTab value, $Res Function(ChangeTab) _then) = _$ChangeTabCopyWithImpl;
@useResult
$Res call({
 int tabIndex
});




}
/// @nodoc
class _$ChangeTabCopyWithImpl<$Res>
    implements $ChangeTabCopyWith<$Res> {
  _$ChangeTabCopyWithImpl(this._self, this._then);

  final ChangeTab _self;
  final $Res Function(ChangeTab) _then;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tabIndex = null,}) {
  return _then(ChangeTab(
null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RefreshBondDetail implements BondDetailEvent {
  const RefreshBondDetail(this.isin);
  

 final  String isin;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshBondDetailCopyWith<RefreshBondDetail> get copyWith => _$RefreshBondDetailCopyWithImpl<RefreshBondDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshBondDetail&&(identical(other.isin, isin) || other.isin == isin));
}


@override
int get hashCode => Object.hash(runtimeType,isin);

@override
String toString() {
  return 'BondDetailEvent.refreshBondDetail(isin: $isin)';
}


}

/// @nodoc
abstract mixin class $RefreshBondDetailCopyWith<$Res> implements $BondDetailEventCopyWith<$Res> {
  factory $RefreshBondDetailCopyWith(RefreshBondDetail value, $Res Function(RefreshBondDetail) _then) = _$RefreshBondDetailCopyWithImpl;
@useResult
$Res call({
 String isin
});




}
/// @nodoc
class _$RefreshBondDetailCopyWithImpl<$Res>
    implements $RefreshBondDetailCopyWith<$Res> {
  _$RefreshBondDetailCopyWithImpl(this._self, this._then);

  final RefreshBondDetail _self;
  final $Res Function(RefreshBondDetail) _then;

/// Create a copy of BondDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isin = null,}) {
  return _then(RefreshBondDetail(
null == isin ? _self.isin : isin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
