// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthUnauthenticatedImplCopyWith<$Res> {
  factory _$$AuthUnauthenticatedImplCopyWith(
    _$AuthUnauthenticatedImpl value,
    $Res Function(_$AuthUnauthenticatedImpl) then,
  ) = __$$AuthUnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthUnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnauthenticatedImpl>
    implements _$$AuthUnauthenticatedImplCopyWith<$Res> {
  __$$AuthUnauthenticatedImplCopyWithImpl(
    _$AuthUnauthenticatedImpl _value,
    $Res Function(_$AuthUnauthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthUnauthenticatedImpl implements AuthUnauthenticated {
  const _$AuthUnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated implements AuthState {
  const factory AuthUnauthenticated() = _$AuthUnauthenticatedImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
    _$AuthLoadingImpl value,
    $Res Function(_$AuthLoadingImpl) then,
  ) = __$$AuthLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
    _$AuthLoadingImpl _value,
    $Res Function(_$AuthLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthState {
  const factory AuthLoading() = _$AuthLoadingImpl;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
    _$AuthErrorImpl value,
    $Res Function(_$AuthErrorImpl) then,
  ) = __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
    _$AuthErrorImpl _value,
    $Res Function(_$AuthErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AuthErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthState {
  const factory AuthError({required final String message}) = _$AuthErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthMfaRequiredImplCopyWith<$Res> {
  factory _$$AuthMfaRequiredImplCopyWith(
    _$AuthMfaRequiredImpl value,
    $Res Function(_$AuthMfaRequiredImpl) then,
  ) = __$$AuthMfaRequiredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool firstLogin, String mfaToken});
}

/// @nodoc
class __$$AuthMfaRequiredImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthMfaRequiredImpl>
    implements _$$AuthMfaRequiredImplCopyWith<$Res> {
  __$$AuthMfaRequiredImplCopyWithImpl(
    _$AuthMfaRequiredImpl _value,
    $Res Function(_$AuthMfaRequiredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? firstLogin = null, Object? mfaToken = null}) {
    return _then(
      _$AuthMfaRequiredImpl(
        firstLogin: null == firstLogin
            ? _value.firstLogin
            : firstLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
        mfaToken: null == mfaToken
            ? _value.mfaToken
            : mfaToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthMfaRequiredImpl implements AuthMfaRequired {
  const _$AuthMfaRequiredImpl({
    required this.firstLogin,
    required this.mfaToken,
  });

  @override
  final bool firstLogin;
  @override
  final String mfaToken;

  @override
  String toString() {
    return 'AuthState.mfaRequired(firstLogin: $firstLogin, mfaToken: $mfaToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthMfaRequiredImpl &&
            (identical(other.firstLogin, firstLogin) ||
                other.firstLogin == firstLogin) &&
            (identical(other.mfaToken, mfaToken) ||
                other.mfaToken == mfaToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstLogin, mfaToken);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthMfaRequiredImplCopyWith<_$AuthMfaRequiredImpl> get copyWith =>
      __$$AuthMfaRequiredImplCopyWithImpl<_$AuthMfaRequiredImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return mfaRequired(firstLogin, mfaToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return mfaRequired?.call(firstLogin, mfaToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (mfaRequired != null) {
      return mfaRequired(firstLogin, mfaToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return mfaRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return mfaRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (mfaRequired != null) {
      return mfaRequired(this);
    }
    return orElse();
  }
}

abstract class AuthMfaRequired implements AuthState {
  const factory AuthMfaRequired({
    required final bool firstLogin,
    required final String mfaToken,
  }) = _$AuthMfaRequiredImpl;

  bool get firstLogin;
  String get mfaToken;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthMfaRequiredImplCopyWith<_$AuthMfaRequiredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPickMembershipImplCopyWith<$Res> {
  factory _$$AuthPickMembershipImplCopyWith(
    _$AuthPickMembershipImpl value,
    $Res Function(_$AuthPickMembershipImpl) then,
  ) = __$$AuthPickMembershipImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Membership> memberships});
}

/// @nodoc
class __$$AuthPickMembershipImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthPickMembershipImpl>
    implements _$$AuthPickMembershipImplCopyWith<$Res> {
  __$$AuthPickMembershipImplCopyWithImpl(
    _$AuthPickMembershipImpl _value,
    $Res Function(_$AuthPickMembershipImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? memberships = null}) {
    return _then(
      _$AuthPickMembershipImpl(
        null == memberships
            ? _value._memberships
            : memberships // ignore: cast_nullable_to_non_nullable
                  as List<Membership>,
      ),
    );
  }
}

/// @nodoc

class _$AuthPickMembershipImpl implements AuthPickMembership {
  const _$AuthPickMembershipImpl(final List<Membership> memberships)
    : _memberships = memberships;

  final List<Membership> _memberships;
  @override
  List<Membership> get memberships {
    if (_memberships is EqualUnmodifiableListView) return _memberships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberships);
  }

  @override
  String toString() {
    return 'AuthState.pickMembership(memberships: $memberships)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPickMembershipImpl &&
            const DeepCollectionEquality().equals(
              other._memberships,
              _memberships,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_memberships),
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPickMembershipImplCopyWith<_$AuthPickMembershipImpl> get copyWith =>
      __$$AuthPickMembershipImplCopyWithImpl<_$AuthPickMembershipImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return pickMembership(memberships);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return pickMembership?.call(memberships);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (pickMembership != null) {
      return pickMembership(memberships);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return pickMembership(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return pickMembership?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (pickMembership != null) {
      return pickMembership(this);
    }
    return orElse();
  }
}

abstract class AuthPickMembership implements AuthState {
  const factory AuthPickMembership(final List<Membership> memberships) =
      _$AuthPickMembershipImpl;

  List<Membership> get memberships;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthPickMembershipImplCopyWith<_$AuthPickMembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAuthenticatedImplCopyWith<$Res> {
  factory _$$AuthAuthenticatedImplCopyWith(
    _$AuthAuthenticatedImpl value,
    $Res Function(_$AuthAuthenticatedImpl) then,
  ) = __$$AuthAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String role, String? tenantId, bool onboardingRequired});
}

/// @nodoc
class __$$AuthAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAuthenticatedImpl>
    implements _$$AuthAuthenticatedImplCopyWith<$Res> {
  __$$AuthAuthenticatedImplCopyWithImpl(
    _$AuthAuthenticatedImpl _value,
    $Res Function(_$AuthAuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? tenantId = freezed,
    Object? onboardingRequired = null,
  }) {
    return _then(
      _$AuthAuthenticatedImpl(
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        onboardingRequired: null == onboardingRequired
            ? _value.onboardingRequired
            : onboardingRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthAuthenticatedImpl implements AuthAuthenticated {
  const _$AuthAuthenticatedImpl({
    required this.role,
    this.tenantId,
    this.onboardingRequired = false,
  });

  @override
  final String role;
  @override
  final String? tenantId;
  @override
  @JsonKey()
  final bool onboardingRequired;

  @override
  String toString() {
    return 'AuthState.authenticated(role: $role, tenantId: $tenantId, onboardingRequired: $onboardingRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticatedImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.onboardingRequired, onboardingRequired) ||
                other.onboardingRequired == onboardingRequired));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, role, tenantId, onboardingRequired);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      __$$AuthAuthenticatedImplCopyWithImpl<_$AuthAuthenticatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return authenticated(role, tenantId, onboardingRequired);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return authenticated?.call(role, tenantId, onboardingRequired);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(role, tenantId, onboardingRequired);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthMfaRequired value) mfaRequired,
    required TResult Function(AuthPickMembership value) pickMembership,
    required TResult Function(AuthAuthenticated value) authenticated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthPickMembership value)? pickMembership,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
    TResult Function(AuthPickMembership value)? pickMembership,
    TResult Function(AuthAuthenticated value)? authenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated implements AuthState {
  const factory AuthAuthenticated({
    required final String role,
    final String? tenantId,
    final bool onboardingRequired,
  }) = _$AuthAuthenticatedImpl;

  String get role;
  String? get tenantId;
  bool get onboardingRequired;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
