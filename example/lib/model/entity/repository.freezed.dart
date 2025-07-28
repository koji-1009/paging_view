// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Repository implements DiagnosticableTreeMixin {

 String get name; int get id; String get fullName; String get description;
/// Create a copy of Repository
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepositoryCopyWith<Repository> get copyWith => _$RepositoryCopyWithImpl<Repository>(this as Repository, _$identity);

  /// Serializes this Repository to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Repository'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('fullName', fullName))..add(DiagnosticsProperty('description', description));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Repository&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,id,fullName,description);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Repository(name: $name, id: $id, fullName: $fullName, description: $description)';
}


}

/// @nodoc
abstract mixin class $RepositoryCopyWith<$Res>  {
  factory $RepositoryCopyWith(Repository value, $Res Function(Repository) _then) = _$RepositoryCopyWithImpl;
@useResult
$Res call({
 String name, int id, String fullName, String description
});




}
/// @nodoc
class _$RepositoryCopyWithImpl<$Res>
    implements $RepositoryCopyWith<$Res> {
  _$RepositoryCopyWithImpl(this._self, this._then);

  final Repository _self;
  final $Res Function(Repository) _then;

/// Create a copy of Repository
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? id = null,Object? fullName = null,Object? description = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Repository].
extension RepositoryPatterns on Repository {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Repository value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Repository() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Repository value)  $default,){
final _that = this;
switch (_that) {
case _Repository():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Repository value)?  $default,){
final _that = this;
switch (_that) {
case _Repository() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int id,  String fullName,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Repository() when $default != null:
return $default(_that.name,_that.id,_that.fullName,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int id,  String fullName,  String description)  $default,) {final _that = this;
switch (_that) {
case _Repository():
return $default(_that.name,_that.id,_that.fullName,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int id,  String fullName,  String description)?  $default,) {final _that = this;
switch (_that) {
case _Repository() when $default != null:
return $default(_that.name,_that.id,_that.fullName,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Repository with DiagnosticableTreeMixin implements Repository {
  const _Repository({required this.name, required this.id, required this.fullName, this.description = ''});
  factory _Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);

@override final  String name;
@override final  int id;
@override final  String fullName;
@override@JsonKey() final  String description;

/// Create a copy of Repository
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepositoryCopyWith<_Repository> get copyWith => __$RepositoryCopyWithImpl<_Repository>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepositoryToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Repository'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('fullName', fullName))..add(DiagnosticsProperty('description', description));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Repository&&(identical(other.name, name) || other.name == name)&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,id,fullName,description);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Repository(name: $name, id: $id, fullName: $fullName, description: $description)';
}


}

/// @nodoc
abstract mixin class _$RepositoryCopyWith<$Res> implements $RepositoryCopyWith<$Res> {
  factory _$RepositoryCopyWith(_Repository value, $Res Function(_Repository) _then) = __$RepositoryCopyWithImpl;
@override @useResult
$Res call({
 String name, int id, String fullName, String description
});




}
/// @nodoc
class __$RepositoryCopyWithImpl<$Res>
    implements _$RepositoryCopyWith<$Res> {
  __$RepositoryCopyWithImpl(this._self, this._then);

  final _Repository _self;
  final $Res Function(_Repository) _then;

/// Create a copy of Repository
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? id = null,Object? fullName = null,Object? description = null,}) {
  return _then(_Repository(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
