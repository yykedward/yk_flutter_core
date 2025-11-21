import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/***
 *


    import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
    import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

    const json = (status: number, body: Record<string, unknown>) =>
    new Response(JSON.stringify(body), { status, headers: { "content-type": "application/json" } });

    function normalizePhone(phone: string): string {
    return phone.trim().replace(/[\s-]/g, "");
    }

    async function findUserByPhone(supabase: any, phone: string) {
    let page = 1;
    const perPage = 200;
    while (true) {
    const { data, error } = await supabase.auth.admin.listUsers({ page, perPage });
    if (error) return undefined;
    const users = data?.users ?? [];
    const found = users.find(
    (u: any) =>
    (typeof u.phone === "string" && normalizePhone(u.phone) === phone) ||
    (typeof u.user_metadata?.phone === "string" && normalizePhone(u.user_metadata.phone) === phone)
    );
    if (found) return found;
    if (users.length < perPage) return undefined;
    page++;
    }
    }

    serve(async (req) => {
    try {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(url, key);
    const body = await req.json();
    const rawPhone = String(body?.phone ?? "");
    const password = String(body?.password ?? "");
    const phone = normalizePhone(rawPhone);
    if (!phone || phone.length < 6) return json(400, { code: 400, message: "手机号不合法" });
    const exists = await findUserByPhone(supabase, phone);
    if (exists) return json(409, { code: 409, message: "用户已注册" });
    const meta: Record<string, unknown> = { user_type: "phone", phone };
    if (typeof body?.nickname === "string" && body.nickname.length > 0) meta.nickname = body.nickname;
    if (typeof body?.name === "string" && body.name.length > 0) meta.name = body.name;
    if (typeof body?.full_name === "string" && body.full_name.length > 0) meta.full_name = body.full_name;
    const { data, error } = await supabase.auth.admin.createUser({
    phone,
    password,
    phone_confirm: true,
    user_metadata: meta,
    });
    if (error) return json(400, { code: 400, message: error.message });
    return json(200, { code: 200, data: { userId: data.user?.id } });
    } catch (e) {
    return json(500, { code: 500, message: String(e) });
    }
    });

 **/

@immutable
class YkUser {
  final String id;
  final String? email;
  final String? phone;
  final String? userType;
  final String? nickname;

  const YkUser({
    required this.id,
    this.email,
    this.phone,
    this.userType,
    this.nickname,
  });
}

class YkSupabaseManager {
  final Logger _logger = Logger('YkSupabaseManager');

  void Function(bool, String?)? _onLoading;

  YkSupabaseManager._internal();

  static final YkSupabaseManager _instance = YkSupabaseManager._internal();

  factory YkSupabaseManager({void Function(bool, String?)? onLoading}) {
    if (onLoading != null) {
      _instance._onLoading = onLoading;
    }
    return _instance;
  }

  static YkSupabaseManager get instance => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  YkUser? get currentYkUser => _toYkUser(_auth.currentUser);

  Stream<YkUser?> get onUserChange =>
      onAuthStateChange.map((e) => _toYkUser(e.session?.user));

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) {
    return Supabase.initialize(url: url, anonKey: anonKey);
  }

  static Future<void> initializeFromEnv() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    return Supabase.initialize(url: url, anonKey: anonKey);
  }

  void setLoadingCallback(void Function(bool, String?)? cb) {
    _onLoading = cb;
  }

  void _notifyLoading(bool isLoading, [String? message]) {
    final cb = _onLoading;
    if (cb != null) {
      cb(isLoading, message);
    }
  }

  Future<T> _withLoading<T>(
      Future<T> Function() action, [
        String? message,
      ]) async {
    _notifyLoading(true, message);
    try {
      final result = await action();
      return result;
    } on PostgrestException catch (e) {
      _error('postgrest: ${e.message}');
      throw Exception(e.message);
    } on AuthException catch (e) {
      _error('auth: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      _error('unexpected: $e');
      throw Exception('$e');
    } finally {
      _notifyLoading(false, null);
    }
  }

  Future<void> authSignInWithPassword(String email, String password) {
    return _withLoading(
          () => _signInWithPassword(email: email, password: password),
    );
  }

  Future<void> authSignInWithPhone(String phone, String password) {
    return _withLoading(
          () => _signInWithPassword(phone: phone, password: password),
    );
  }

  Future<void> authSignUp(String email, String password) async {
    await _withLoading(
          () => _signUp(email: email, password: password, logTag: 'email'),
    );
  }

  Future<void> authSignUpWithMetadata(
      String email,
      String password, {
        Map<String, dynamic>? data,
      }) async {
    await _withLoading(
          () => _signUp(
        email: email,
        password: password,
        data: data,
        logTag: 'email+metadata',
      ),
    );
  }

  Future<void> authSignUpPhoneWithMetadata(
      String phone,
      String password, {
        Map<String, dynamic>? data,
      }) async {
    await _withLoading(
          () => _signUp(
        phone: phone,
        password: password,
        data: data,
        logTag: 'phone+metadata',
      ),
    );
  }

  Future<void> authSignOut() {
    return _withLoading(() => _auth.signOut());
  }

  Future<void> authResetPasswordForEmail(
      String email, {
        required String redirectTo,
      }) {
    return _withLoading(
          () => _auth.resetPasswordForEmail(email, redirectTo: redirectTo),
    );
  }

  Future<void> authUpdatePassword(String password) {
    return _withLoading(
          () => _updateUser(password: password, logTag: 'password'),
    );
  }

  Future<void> authUpdateUserMetadata(Map<String, dynamic> data) {
    return _withLoading(() => _updateUser(data: data, logTag: 'metadata'));
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
    return _withLoading(() async {
      dynamic q = _client.from(table).select();
      q = _applyEq(q, eq);
      q = _applyIn(q, inFilter);
      q = _applyOrder(q, orderBy, ascending);
      q = _applyLimit(q, limit);
      final res = await q;
      return (res as List).cast<Map<String, dynamic>>();
    });
  }

  Future<Map<String, dynamic>> dbInsert(
      String table,
      Map<String, dynamic> values,
      ) async {
    return _withLoading(() async {
      final res = await _client.from(table).insert(values).select().single();
      return res;
    });
  }

  Future<Map<String, dynamic>> dbUpdate(
      String table,
      Map<String, dynamic> values, {
        Map<String, dynamic>? eq,
      }) async {
    return _withLoading(() async {
      dynamic q = _client.from(table).update(values);
      q = _applyEq(q, eq);
      final res = await q.select().single();
      return (res as Map<String, dynamic>);
    });
  }

  Future<void> dbDelete(String table, {Map<String, dynamic>? eq}) async {
    return _withLoading(() async {
      dynamic q = _client.from(table).delete();
      q = _applyEq(q, eq);
      await q;
    });
  }

  Future<dynamic> dbRpc(String fn, Map<String, dynamic> params) async {
    return _withLoading(() async {
      final res = await _client.rpc(fn, params: params);
      return res;
    });
  }

  Future<dynamic> fnInvoke(String name, {dynamic body}) async {
    return _withLoading(() async {
      final res = await _client.functions.invoke(name, body: body);
      return res.data;
    });
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }

  Future<Map<String, dynamic>> authRegisterPhoneViaEdge(
      String phone,
      String password, {
        Map<String, dynamic>? metadata,
      }) async {
    return _withLoading(() async {
      if (!_isStrongPassword(password)) {
        return {'code': 400, 'message': '密码不符合安全要求'};
      }
      final Map<String, dynamic> payload = {
        'phone': phone,
        'password': password,
      };
      if (metadata != null) {
        payload.addAll(metadata);
      }
      final data = await fnInvoke('register-phone-user', body: payload);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'code': 500, 'message': '服务响应异常'};
    }, '正在注册');
  }

  Future<void> _signUp({
    String? email,
    String? phone,
    required String password,
    Map<String, dynamic>? data,
    required String logTag,
  }) async {
    final res = await _auth.signUp(
      email: email,
      phone: phone,
      password: password,
      data: data,
    );
    if (res.user == null && res.session == null) {
      _log('signUp($logTag) returned no user/session');
    }
  }

  Future<void> _signInWithPassword({
    String? email,
    String? phone,
    required String password,
  }) {
    return _auth.signInWithPassword(
      email: email,
      phone: phone,
      password: password,
    );
  }

  Future<void> _updateUser({
    String? password,
    Map<String, dynamic>? data,
    String? logTag,
  }) async {
    await _auth.updateUser(UserAttributes(password: password, data: data));
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

  dynamic _applyIn(dynamic q, Map<String, List<dynamic>>? inFilter) {
    if (inFilter != null) {
      for (final entry in inFilter.entries) {
        q = q.in_(entry.key, entry.value);
      }
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
