// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthSession {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  Claims get claims => throw _privateConstructorUsedError;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSessionCopyWith<AuthSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionCopyWith<$Res> {
  factory $AuthSessionCopyWith(
    AuthSession value,
    $Res Function(AuthSession) then,
  ) = _$AuthSessionCopyWithImpl<$Res, AuthSession>;
  @useResult
  $Res call({String accessToken, String refreshToken, Claims claims});
}

/// @nodoc
class _$AuthSessionCopyWithImpl<$Res, $Val extends AuthSession>
    implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? claims = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            claims: null == claims
                ? _value.claims
                : claims // ignore: cast_nullable_to_non_nullable
                      as Claims,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthSessionImplCopyWith<$Res>
    implements $AuthSessionCopyWith<$Res> {
  factory _$$AuthSessionImplCopyWith(
    _$AuthSessionImpl value,
    $Res Function(_$AuthSessionImpl) then,
  ) = __$$AuthSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken, String refreshToken, Claims claims});
}

/// @nodoc
class __$$AuthSessionImplCopyWithImpl<$Res>
    extends _$AuthSessionCopyWithImpl<$Res, _$AuthSessionImpl>
    implements _$$AuthSessionImplCopyWith<$Res> {
  __$$AuthSessionImplCopyWithImpl(
    _$AuthSessionImpl _value,
    $Res Function(_$AuthSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? claims = null,
  }) {
    return _then(
      _$AuthSessionImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        claims: null == claims
            ? _value.claims
            : claims // ignore: cast_nullable_to_non_nullable
                  as Claims,
      ),
    );
  }
}

/// @nodoc

class _$AuthSessionImpl extends _AuthSession {
  const _$AuthSessionImpl({
    required this.accessToken,
    required this.refreshToken,
    required this.claims,
  }) : super._();

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final Claims claims;

  @override
  String toString() {
    return 'AuthSession(accessToken: $accessToken, refreshToken: $refreshToken, claims: $claims)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.claims, claims) || other.claims == claims));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, claims);

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionImplCopyWith<_$AuthSessionImpl> get copyWith =>
      __$$AuthSessionImplCopyWithImpl<_$AuthSessionImpl>(this, _$identity);
}

abstract class _AuthSession extends AuthSession {
  const factory _AuthSession({
    required final String accessToken,
    required final String refreshToken,
    required final Claims claims,
  }) = _$AuthSessionImpl;
  const _AuthSession._() : super._();

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  Claims get claims;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSessionImplCopyWith<_$AuthSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Membership _$MembershipFromJson(Map<String, dynamic> json) {
  return _Membership.fromJson(json);
}

/// @nodoc
mixin _$Membership {
  String get tenantId => throw _privateConstructorUsedError;
  String get tenantName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this Membership to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Membership
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MembershipCopyWith<Membership> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipCopyWith<$Res> {
  factory $MembershipCopyWith(
    Membership value,
    $Res Function(Membership) then,
  ) = _$MembershipCopyWithImpl<$Res, Membership>;
  @useResult
  $Res call({String tenantId, String tenantName, String role});
}

/// @nodoc
class _$MembershipCopyWithImpl<$Res, $Val extends Membership>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Membership
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? tenantName = null,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as String,
            tenantName: null == tenantName
                ? _value.tenantName
                : tenantName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MembershipImplCopyWith<$Res>
    implements $MembershipCopyWith<$Res> {
  factory _$$MembershipImplCopyWith(
    _$MembershipImpl value,
    $Res Function(_$MembershipImpl) then,
  ) = __$$MembershipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tenantId, String tenantName, String role});
}

/// @nodoc
class __$$MembershipImplCopyWithImpl<$Res>
    extends _$MembershipCopyWithImpl<$Res, _$MembershipImpl>
    implements _$$MembershipImplCopyWith<$Res> {
  __$$MembershipImplCopyWithImpl(
    _$MembershipImpl _value,
    $Res Function(_$MembershipImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Membership
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tenantId = null,
    Object? tenantName = null,
    Object? role = null,
  }) {
    return _then(
      _$MembershipImpl(
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as String,
        tenantName: null == tenantName
            ? _value.tenantName
            : tenantName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipImpl implements _Membership {
  const _$MembershipImpl({
    required this.tenantId,
    required this.tenantName,
    required this.role,
  });

  factory _$MembershipImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipImplFromJson(json);

  @override
  final String tenantId;
  @override
  final String tenantName;
  @override
  final String role;

  @override
  String toString() {
    return 'Membership(tenantId: $tenantId, tenantName: $tenantName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipImpl &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.tenantName, tenantName) ||
                other.tenantName == tenantName) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tenantId, tenantName, role);

  /// Create a copy of Membership
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith =>
      __$$MembershipImplCopyWithImpl<_$MembershipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipImplToJson(this);
  }
}

abstract class _Membership implements Membership {
  const factory _Membership({
    required final String tenantId,
    required final String tenantName,
    required final String role,
  }) = _$MembershipImpl;

  factory _Membership.fromJson(Map<String, dynamic> json) =
      _$MembershipImpl.fromJson;

  @override
  String get tenantId;
  @override
  String get tenantName;
  @override
  String get role;

  /// Create a copy of Membership
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MembershipImplCopyWith<_$MembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LoginResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthSession session) session,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthSession session)? session,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthSession session)? session,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSession value) session,
    required TResult Function(LoginMfaRequired value) mfaRequired,
    required TResult Function(LoginPickMembership value) pickMembership,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSession value)? session,
    TResult? Function(LoginMfaRequired value)? mfaRequired,
    TResult? Function(LoginPickMembership value)? pickMembership,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSession value)? session,
    TResult Function(LoginMfaRequired value)? mfaRequired,
    TResult Function(LoginPickMembership value)? pickMembership,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResultCopyWith<$Res> {
  factory $LoginResultCopyWith(
    LoginResult value,
    $Res Function(LoginResult) then,
  ) = _$LoginResultCopyWithImpl<$Res, LoginResult>;
}

/// @nodoc
class _$LoginResultCopyWithImpl<$Res, $Val extends LoginResult>
    implements $LoginResultCopyWith<$Res> {
  _$LoginResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginSessionImplCopyWith<$Res> {
  factory _$$LoginSessionImplCopyWith(
    _$LoginSessionImpl value,
    $Res Function(_$LoginSessionImpl) then,
  ) = __$$LoginSessionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthSession session});

  $AuthSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$LoginSessionImplCopyWithImpl<$Res>
    extends _$LoginResultCopyWithImpl<$Res, _$LoginSessionImpl>
    implements _$$LoginSessionImplCopyWith<$Res> {
  __$$LoginSessionImplCopyWithImpl(
    _$LoginSessionImpl _value,
    $Res Function(_$LoginSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? session = null}) {
    return _then(
      _$LoginSessionImpl(
        null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as AuthSession,
      ),
    );
  }

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthSessionCopyWith<$Res> get session {
    return $AuthSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value));
    });
  }
}

/// @nodoc

class _$LoginSessionImpl implements LoginSession {
  const _$LoginSessionImpl(this.session);

  @override
  final AuthSession session;

  @override
  String toString() {
    return 'LoginResult.session(session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginSessionImpl &&
            (identical(other.session, session) || other.session == session));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session);

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginSessionImplCopyWith<_$LoginSessionImpl> get copyWith =>
      __$$LoginSessionImplCopyWithImpl<_$LoginSessionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthSession session) session,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
  }) {
    return session(this.session);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthSession session)? session,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
  }) {
    return session?.call(this.session);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthSession session)? session,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
    required TResult orElse(),
  }) {
    if (session != null) {
      return session(this.session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSession value) session,
    required TResult Function(LoginMfaRequired value) mfaRequired,
    required TResult Function(LoginPickMembership value) pickMembership,
  }) {
    return session(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSession value)? session,
    TResult? Function(LoginMfaRequired value)? mfaRequired,
    TResult? Function(LoginPickMembership value)? pickMembership,
  }) {
    return session?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSession value)? session,
    TResult Function(LoginMfaRequired value)? mfaRequired,
    TResult Function(LoginPickMembership value)? pickMembership,
    required TResult orElse(),
  }) {
    if (session != null) {
      return session(this);
    }
    return orElse();
  }
}

abstract class LoginSession implements LoginResult {
  const factory LoginSession(final AuthSession session) = _$LoginSessionImpl;

  AuthSession get session;

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginSessionImplCopyWith<_$LoginSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginMfaRequiredImplCopyWith<$Res> {
  factory _$$LoginMfaRequiredImplCopyWith(
    _$LoginMfaRequiredImpl value,
    $Res Function(_$LoginMfaRequiredImpl) then,
  ) = __$$LoginMfaRequiredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool firstLogin, String mfaToken});
}

/// @nodoc
class __$$LoginMfaRequiredImplCopyWithImpl<$Res>
    extends _$LoginResultCopyWithImpl<$Res, _$LoginMfaRequiredImpl>
    implements _$$LoginMfaRequiredImplCopyWith<$Res> {
  __$$LoginMfaRequiredImplCopyWithImpl(
    _$LoginMfaRequiredImpl _value,
    $Res Function(_$LoginMfaRequiredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? firstLogin = null, Object? mfaToken = null}) {
    return _then(
      _$LoginMfaRequiredImpl(
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

class _$LoginMfaRequiredImpl implements LoginMfaRequired {
  const _$LoginMfaRequiredImpl({
    required this.firstLogin,
    required this.mfaToken,
  });

  @override
  final bool firstLogin;
  @override
  final String mfaToken;

  @override
  String toString() {
    return 'LoginResult.mfaRequired(firstLogin: $firstLogin, mfaToken: $mfaToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginMfaRequiredImpl &&
            (identical(other.firstLogin, firstLogin) ||
                other.firstLogin == firstLogin) &&
            (identical(other.mfaToken, mfaToken) ||
                other.mfaToken == mfaToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstLogin, mfaToken);

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginMfaRequiredImplCopyWith<_$LoginMfaRequiredImpl> get copyWith =>
      __$$LoginMfaRequiredImplCopyWithImpl<_$LoginMfaRequiredImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthSession session) session,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
  }) {
    return mfaRequired(firstLogin, mfaToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthSession session)? session,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
  }) {
    return mfaRequired?.call(firstLogin, mfaToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthSession session)? session,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
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
    required TResult Function(LoginSession value) session,
    required TResult Function(LoginMfaRequired value) mfaRequired,
    required TResult Function(LoginPickMembership value) pickMembership,
  }) {
    return mfaRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSession value)? session,
    TResult? Function(LoginMfaRequired value)? mfaRequired,
    TResult? Function(LoginPickMembership value)? pickMembership,
  }) {
    return mfaRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSession value)? session,
    TResult Function(LoginMfaRequired value)? mfaRequired,
    TResult Function(LoginPickMembership value)? pickMembership,
    required TResult orElse(),
  }) {
    if (mfaRequired != null) {
      return mfaRequired(this);
    }
    return orElse();
  }
}

abstract class LoginMfaRequired implements LoginResult {
  const factory LoginMfaRequired({
    required final bool firstLogin,
    required final String mfaToken,
  }) = _$LoginMfaRequiredImpl;

  bool get firstLogin;
  String get mfaToken;

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginMfaRequiredImplCopyWith<_$LoginMfaRequiredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginPickMembershipImplCopyWith<$Res> {
  factory _$$LoginPickMembershipImplCopyWith(
    _$LoginPickMembershipImpl value,
    $Res Function(_$LoginPickMembershipImpl) then,
  ) = __$$LoginPickMembershipImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Membership> memberships});
}

/// @nodoc
class __$$LoginPickMembershipImplCopyWithImpl<$Res>
    extends _$LoginResultCopyWithImpl<$Res, _$LoginPickMembershipImpl>
    implements _$$LoginPickMembershipImplCopyWith<$Res> {
  __$$LoginPickMembershipImplCopyWithImpl(
    _$LoginPickMembershipImpl _value,
    $Res Function(_$LoginPickMembershipImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? memberships = null}) {
    return _then(
      _$LoginPickMembershipImpl(
        null == memberships
            ? _value._memberships
            : memberships // ignore: cast_nullable_to_non_nullable
                  as List<Membership>,
      ),
    );
  }
}

/// @nodoc

class _$LoginPickMembershipImpl implements LoginPickMembership {
  const _$LoginPickMembershipImpl(final List<Membership> memberships)
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
    return 'LoginResult.pickMembership(memberships: $memberships)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginPickMembershipImpl &&
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

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginPickMembershipImplCopyWith<_$LoginPickMembershipImpl> get copyWith =>
      __$$LoginPickMembershipImplCopyWithImpl<_$LoginPickMembershipImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthSession session) session,
    required TResult Function(bool firstLogin, String mfaToken) mfaRequired,
    required TResult Function(List<Membership> memberships) pickMembership,
  }) {
    return pickMembership(memberships);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthSession session)? session,
    TResult? Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult? Function(List<Membership> memberships)? pickMembership,
  }) {
    return pickMembership?.call(memberships);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthSession session)? session,
    TResult Function(bool firstLogin, String mfaToken)? mfaRequired,
    TResult Function(List<Membership> memberships)? pickMembership,
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
    required TResult Function(LoginSession value) session,
    required TResult Function(LoginMfaRequired value) mfaRequired,
    required TResult Function(LoginPickMembership value) pickMembership,
  }) {
    return pickMembership(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSession value)? session,
    TResult? Function(LoginMfaRequired value)? mfaRequired,
    TResult? Function(LoginPickMembership value)? pickMembership,
  }) {
    return pickMembership?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSession value)? session,
    TResult Function(LoginMfaRequired value)? mfaRequired,
    TResult Function(LoginPickMembership value)? pickMembership,
    required TResult orElse(),
  }) {
    if (pickMembership != null) {
      return pickMembership(this);
    }
    return orElse();
  }
}

abstract class LoginPickMembership implements LoginResult {
  const factory LoginPickMembership(final List<Membership> memberships) =
      _$LoginPickMembershipImpl;

  List<Membership> get memberships;

  /// Create a copy of LoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginPickMembershipImplCopyWith<_$LoginPickMembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
