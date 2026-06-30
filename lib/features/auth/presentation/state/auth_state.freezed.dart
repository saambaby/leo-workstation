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
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
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
    required TResult Function(AuthAuthenticated value) authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthMfaRequired value)? mfaRequired,
    TResult? Function(AuthAuthenticated value)? authenticated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthError value)? error,
    TResult Function(AuthMfaRequired value)? mfaRequired,
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
  @useResult
  $Res call({bool forgotPasswordSending, bool resendCodeSending});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forgotPasswordSending = null,
    Object? resendCodeSending = null,
  }) {
    return _then(
      _$AuthUnauthenticatedImpl(
        forgotPasswordSending: null == forgotPasswordSending
            ? _value.forgotPasswordSending
            : forgotPasswordSending // ignore: cast_nullable_to_non_nullable
                  as bool,
        resendCodeSending: null == resendCodeSending
            ? _value.resendCodeSending
            : resendCodeSending // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthUnauthenticatedImpl implements AuthUnauthenticated {
  const _$AuthUnauthenticatedImpl({
    this.forgotPasswordSending = false,
    this.resendCodeSending = false,
  });

  @override
  @JsonKey()
  final bool forgotPasswordSending;
  @override
  @JsonKey()
  final bool resendCodeSending;

  @override
  String toString() {
    return 'AuthState.unauthenticated(forgotPasswordSending: $forgotPasswordSending, resendCodeSending: $resendCodeSending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticatedImpl &&
            (identical(other.forgotPasswordSending, forgotPasswordSending) ||
                other.forgotPasswordSending == forgotPasswordSending) &&
            (identical(other.resendCodeSending, resendCodeSending) ||
                other.resendCodeSending == resendCodeSending));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, forgotPasswordSending, resendCodeSending);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      __$$AuthUnauthenticatedImplCopyWithImpl<_$AuthUnauthenticatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return unauthenticated(forgotPasswordSending, resendCodeSending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return unauthenticated?.call(forgotPasswordSending, resendCodeSending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(forgotPasswordSending, resendCodeSending);
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
  const factory AuthUnauthenticated({
    final bool forgotPasswordSending,
    final bool resendCodeSending,
  }) = _$AuthUnauthenticatedImpl;

  bool get forgotPasswordSending;
  bool get resendCodeSending;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUnauthenticatedImplCopyWith<_$AuthUnauthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
    _$AuthLoadingImpl value,
    $Res Function(_$AuthLoadingImpl) then,
  ) = __$$AuthLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthLoadingReason reason});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$AuthLoadingImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as AuthLoadingReason,
      ),
    );
  }
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl({this.reason = AuthLoadingReason.session});

  @override
  @JsonKey()
  final AuthLoadingReason reason;

  @override
  String toString() {
    return 'AuthState.loading(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoadingImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      __$$AuthLoadingImplCopyWithImpl<_$AuthLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return loading(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return loading?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(reason);
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
  const factory AuthLoading({final AuthLoadingReason reason}) =
      _$AuthLoadingImpl;

  AuthLoadingReason get reason;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
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
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
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
  $Res call({
    bool firstLogin,
    String? enrollmentToken,
    String? otpauthUrl,
    String? secret,
  });
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
  $Res call({
    Object? firstLogin = null,
    Object? enrollmentToken = freezed,
    Object? otpauthUrl = freezed,
    Object? secret = freezed,
  }) {
    return _then(
      _$AuthMfaRequiredImpl(
        firstLogin: null == firstLogin
            ? _value.firstLogin
            : firstLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
        enrollmentToken: freezed == enrollmentToken
            ? _value.enrollmentToken
            : enrollmentToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        otpauthUrl: freezed == otpauthUrl
            ? _value.otpauthUrl
            : otpauthUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        secret: freezed == secret
            ? _value.secret
            : secret // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthMfaRequiredImpl implements AuthMfaRequired {
  const _$AuthMfaRequiredImpl({
    required this.firstLogin,
    this.enrollmentToken,
    this.otpauthUrl,
    this.secret,
  });

  @override
  final bool firstLogin;
  @override
  final String? enrollmentToken;
  @override
  final String? otpauthUrl;
  @override
  final String? secret;

  @override
  String toString() {
    return 'AuthState.mfaRequired(firstLogin: $firstLogin, enrollmentToken: $enrollmentToken, otpauthUrl: $otpauthUrl, secret: $secret)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthMfaRequiredImpl &&
            (identical(other.firstLogin, firstLogin) ||
                other.firstLogin == firstLogin) &&
            (identical(other.enrollmentToken, enrollmentToken) ||
                other.enrollmentToken == enrollmentToken) &&
            (identical(other.otpauthUrl, otpauthUrl) ||
                other.otpauthUrl == otpauthUrl) &&
            (identical(other.secret, secret) || other.secret == secret));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, firstLogin, enrollmentToken, otpauthUrl, secret);

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
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
    required TResult Function(
      String role,
      String? tenantId,
      bool onboardingRequired,
    )
    authenticated,
  }) {
    return mfaRequired(firstLogin, enrollmentToken, otpauthUrl, secret);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return mfaRequired?.call(firstLogin, enrollmentToken, otpauthUrl, secret);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
    required TResult orElse(),
  }) {
    if (mfaRequired != null) {
      return mfaRequired(firstLogin, enrollmentToken, otpauthUrl, secret);
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
    final String? enrollmentToken,
    final String? otpauthUrl,
    final String? secret,
  }) = _$AuthMfaRequiredImpl;

  bool get firstLogin;
  String? get enrollmentToken;
  String? get otpauthUrl;
  String? get secret;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthMfaRequiredImplCopyWith<_$AuthMfaRequiredImpl> get copyWith =>
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
    required TResult Function(
      bool forgotPasswordSending,
      bool resendCodeSending,
    )
    unauthenticated,
    required TResult Function(AuthLoadingReason reason) loading,
    required TResult Function(String message) error,
    required TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )
    mfaRequired,
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
    TResult? Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult? Function(AuthLoadingReason reason)? loading,
    TResult? Function(String message)? error,
    TResult? Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
    TResult? Function(String role, String? tenantId, bool onboardingRequired)?
    authenticated,
  }) {
    return authenticated?.call(role, tenantId, onboardingRequired);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forgotPasswordSending, bool resendCodeSending)?
    unauthenticated,
    TResult Function(AuthLoadingReason reason)? loading,
    TResult Function(String message)? error,
    TResult Function(
      bool firstLogin,
      String? enrollmentToken,
      String? otpauthUrl,
      String? secret,
    )?
    mfaRequired,
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
