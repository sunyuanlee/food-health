import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/services/phone_auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isOneClickLoading = false;

  final _phoneAuthService = PhoneAuthService();

  // 阿里云控制台的方案 code
  static const _aliSchemeCode = 'FC220000012995060';

  @override
  void dispose() {
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    ref.read(authProvider.notifier).login(
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  Future<void> _oneClickLogin() async {
    setState(() => _isOneClickLoading = true);
    try {
      debugPrint('[OneClickLogin] 开始获取 token');
      final token = await _phoneAuthService.getLoginToken(
        sceneCode: _aliSchemeCode,
      );
      debugPrint('[OneClickLogin] 获取 token 成功: ${token.substring(0, token.length.clamp(0, 10))}...');
      if (!mounted) return;
      await ref.read(authProvider.notifier).phoneLogin(token: token);
      debugPrint('[OneClickLogin] phoneLogin 完成');
    } on PlatformException catch (e) {
      debugPrint('[OneClickLogin] PlatformException: code=${e.code}, msg=${e.message}');
      if (!mounted) return;
      // 用户主动取消，静默处理
      if (e.code == 'CANCELLED') return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? '一键登录失败，请重试'),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (e) {
      debugPrint('[OneClickLogin] 异常: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isOneClickLoading = false);
    }
  }

  InputDecoration _darkInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, state) {
      if (state is AuthAuthenticated) {
        context.go(AppRoutes.home);
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
        );
      }
    });

    final isLoading = ref.watch(authProvider) is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A1A00), Color(0xFF111111)],
              ),
            ),
          ),
          // 装饰圆圈
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          // 主内容
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  // 返回按钮
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white.withOpacity(0.7), size: 20),
                      onPressed: () => context.go(AppRoutes.splash),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // logo + 标题
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.fitness_center,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '健身搭子',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '一起流汗，一起变强',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 52),
                  // 欢迎文字
                  const Text(
                    '欢迎回来',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '登录以继续你的健身旅程',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 表单
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _phoneCtrl,
                          focusNode: _phoneFocus,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_passwordFocus),
                          decoration: _darkInputDecoration(
                            hint: '手机号',
                            icon: Icons.phone_outlined,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return '请输入手机号';
                            if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(v.trim())) {
                              return '请输入有效的手机号';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          onFieldSubmitted: (_) => _submit(),
                          decoration: _darkInputDecoration(
                            hint: '密码（至少 6 位）',
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white.withOpacity(0.4),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return '请输入密码';
                            if (v.length < 6) return '密码至少 6 位';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 登录按钮
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text(
                            '登录',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                  ),
                  const SizedBox(height: 20),
                  // 跳转注册
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '还没有账号？',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.45), fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.smsLogin),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: const Text('立即注册',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 分隔线
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                            color: Colors.white.withOpacity(0.15), height: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '或',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                            color: Colors.white.withOpacity(0.15), height: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 一键登录
                  ElevatedButton.icon(
                    onPressed: (_isOneClickLoading || isLoading) ? null : _oneClickLogin,
                    icon: _isOneClickLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.phone_iphone, size: 20),
                    label: const Text(
                      '本机号码一键登录',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFF1677FF).withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                  ),
                  // TODO: 短信验证码登录（阿里云短信服务企业资质审核通过后启用）
                  // const SizedBox(height: 12),
                  // OutlinedButton.icon(
                  //   onPressed: () => context.push(AppRoutes.smsLogin),
                  //   icon: const Icon(Icons.sms_outlined, size: 20),
                  //   label: const Text(
                  //     '短信验证码登录',
                  //     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  //   ),
                  //   style: OutlinedButton.styleFrom(
                  //     foregroundColor: Colors.white.withOpacity(0.75),
                  //     side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  //     padding: const EdgeInsets.symmetric(vertical: 14),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(28),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
