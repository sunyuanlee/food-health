import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../data/auth_repository.dart';

// ── Auth 状态 ──────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ── Notifier ───────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial());

  final _repo = AuthRepository.instance;

  /// 启动时恢复 session
  Future<void> restoreSession() async {
    state = const AuthLoading();
    final user = await _repo.tryRestoreSession();
    state = user != null
        ? AuthAuthenticated(user)
        : const AuthUnauthenticated();
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repo.login(phone: phone, password: password);
      state = AuthAuthenticated(user);
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('网络异常，请稍后重试');
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String nickname,
    String? city,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repo.register(
        phone: phone,
        password: password,
        nickname: nickname,
        city: city,
      );
      state = AuthAuthenticated(user);
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('网络异常，请稍后重试');
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthUnauthenticated();
  }

  /// 号码认证一键登录
  Future<void> phoneLogin({required String token}) async {
    state = const AuthLoading();
    try {
      final user = await _repo.phoneLogin(token: token);
      state = AuthAuthenticated(user);
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('一键登录失败，请重试');
    }
  }

  Future<void> smsLogin({
    required String phone,
    required String code,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repo.smsLogin(phone: phone, code: code);
      state = AuthAuthenticated(user);
    } on AuthException catch (e) {
      state = AuthError(e.message);
    } catch (_) {
      state = const AuthError('网络异常，请稍后重试');
    }
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
