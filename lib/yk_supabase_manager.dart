import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

@immutable
class YkUser {
  final String id;
  final String? email;
  final String? phone;
  final String? userType;
  final String? nickname;

  const YkUser({required this.id, this.email, this.phone, this.userType, this.nickname});
}

class YkSupabaseManager {
  final Logger _logger = Logger('YkSupabaseManager');

  SupabaseClient get _client => Supabase.instance.client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  YkUser? get currentYkUser => _toYkUser(_auth.currentUser);

  Stream<YkUser?> get onUserChange => onAuthStateChange.map((e) => _toYkUser(e.session?.user));

  static Future<void> initialize({required String url, required String anonKey}) {
    return Supabase.initialize(url: url, anonKey: anonKey);
  }

  static Future<void> initializeFromEnv() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    return Supabase.initialize(url: url, anonKey: anonKey);
  }

  Future<void> authSignInWithPassword(String email, String password) {
    return _signInWithPassword(email: email, password: password);
  }

  Future<void> authSignInWithPhone(String phone, String password) {
    return _signInWithPassword(phone: phone, password: password);
  }

  Future<void> authSignUp(String email, String password) async {
    await _signUp(email: email, password: password, logTag: 'email');
  }

  Future<void> authSignUpWithMetadata(String email, String password, {Map<String, dynamic>? data}) async {
    await _signUp(email: email, password: password, data: data, logTag: 'email+metadata');
  }

  Future<void> authSignUpPhoneWithMetadata(String phone, String password, {Map<String, dynamic>? data}) async {
    await _signUp(phone: phone, password: password, data: data, logTag: 'phone+metadata');
  }

  Future<void> authSignOut() {
    return _auth.signOut();
  }

  Future<void> authResetPasswordForEmail(String email, {required String redirectTo}) {
    return _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  Future<void> authUpdatePassword(String password) {
    return _updateUser(password: password, logTag: 'password');
  }

  Future<void> authUpdateUserMetadata(Map<String, dynamic> data) {
    return _updateUser(data: data, logTag: 'metadata');
  }

  YkUser? _toYkUser(User? user) {
    if (user == null) return null;
    final meta = user.userMetadata ?? {};
    return YkUser(
      id: user.id,
      email: user.email,
      phone: meta['phone'] as String?,
      userType: meta['user_type'] as String?,
      nickname: meta['nickname'] as String?,
    );
  }

  Future<String> getDeviceId() async {
    if (kIsWeb) {
      return 'web';
    }
    try {
      final id = await FlutterUdid.consistentUdid;
      return id ?? 'unknown';
    } catch (e) {
      _log('getDeviceId failed: $e');
      return 'unknown';
    }
  }

  Future<List<Map<String, dynamic>>> dbSelect(
      String table, {
        String? orderBy,
        bool ascending = true,
        Map<String, dynamic>? eq,
        Map<String, List<dynamic>>? inFilter,
        int? limit,
      }) async {
    dynamic q = _client.from(table).select();
    q = _applyOrder(q, orderBy, ascending);
    q = _applyEq(q, eq);
    q = _applyLimit(q, limit);
    final res = await q;
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> dbInsert(String table, Map<String, dynamic> values) async {
    final res = await _client.from(table).insert(values).select().single();
    return (res as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> dbUpdate(String table, Map<String, dynamic> values, {Map<String, dynamic>? eq}) async {
    dynamic q = _client.from(table).update(values);
    q = _applyEq(q, eq);
    final res = await q.select().single();
    return (res as Map<String, dynamic>);
  }

  Future<void> dbDelete(String table, {Map<String, dynamic>? eq}) async {
    dynamic q = _client.from(table).delete();
    q = _applyEq(q, eq);
    await q;
  }

  Future<void> _signUp({String? email, String? phone, required String password, Map<String, dynamic>? data, required String logTag}) async {
    try {
      final res = await _auth.signUp(email: email, phone: phone, password: password, data: data);
      if (res.user == null && res.session == null) {
        _log('signUp($logTag) returned no user/session');
      }
    } on AuthException catch (e) {
      _error('signUp($logTag) failed: ${e.message}');
      rethrow;
    } catch (e) {
      _error('signUp($logTag) unexpected: $e');
      rethrow;
    }
  }

  Future<void> _signInWithPassword({String? email, String? phone, required String password}) {
    return _auth.signInWithPassword(email: email, phone: phone, password: password);
  }

  Future<void> _updateUser({String? password, Map<String, dynamic>? data, String? logTag}) async {
    try {
      await _auth.updateUser(UserAttributes(password: password, data: data));
    } on AuthException catch (e) {
      _error('updateUser(${logTag ?? ''}) failed: ${e.message}');
      rethrow;
    } catch (e) {
      _error('updateUser(${logTag ?? ''}) unexpected: $e');
      rethrow;
    }
  }

  dynamic _applyEq(dynamic q, Map<String, dynamic>? eq) {
    if (eq != null) {
      for (final entry in eq.entries) {
        q = q.eq(entry.key, entry.value);
      }
    }
    return q;
  }

  dynamic _applyOrder(dynamic q, String? orderBy, bool ascending) {
    if (orderBy != null) {
      q = q.order(orderBy, ascending: ascending);
    }
    return q;
  }

  dynamic _applyLimit(dynamic q, int? limit) {
    if (limit != null) {
      q = q.limit(limit);
    }
    return q;
  }

  _log(String msg) {
    _logger.warning(msg);
  }

  _error(String msg) {
    _logger.severe(msg);
  }
}
