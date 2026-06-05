import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/analysis_repository.dart';
import '../../core/providers/food_provider.dart';
import '../../core/router/app_router.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  bool _torchOn = false;
  List<String> _detectedItems = [];

  late final AnimationController _scanLineCtrl;
  late final Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnim = CurvedAnimation(
      parent: _scanLineCtrl,
      curve: Curves.easeInOut,
    );
    // 进入扫描页时自动唤起系统相机
    WidgetsBinding.instance.addPostFrameCallback((_) => _takePhoto());
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      await _startAnalysis(image.path);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (!mounted) return;
    if (image != null) {
      await _startAnalysis(image.path);
    } else {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _toggleTorch() async {
    setState(() => _torchOn = !_torchOn);
  }

  /// 真实调用后端 AI 分析接口
  Future<void> _startAnalysis(String imagePath) async {
    setState(() {
      _isScanning = true;
      _detectedItems = [];
    });

    // 开始动画模拟进度（给用户视觉反馈）
    final progressItems = ['正在识别配料表...', '分析成分风险...', '结合健康目标评分...'];
    int i = 0;
    final progressTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i < progressItems.length) {
        setState(() => _detectedItems.add(progressItems[i]));
        i++;
      } else {
        t.cancel();
      }
    });

    try {
      final goals = ref.read(healthGoalsProvider).map((g) => g.name).toList();
      final analysis = await AnalysisRepository.instance.scan(
        imagePath: imagePath,
        goals: goals,
      );

      progressTimer.cancel();
      if (!mounted) return;

      ref.read(analysisHistoryProvider.notifier).addAnalysis(analysis);
      setState(() => _isScanning = false);
      context.push(AppRoutes.analysisResult, extra: analysis);
    } on AnalysisException catch (e) {
      progressTimer.cancel();
      debugPrint('[ScanPage] AnalysisException: ${e.message}');
      if (!mounted) return;
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e, st) {
      progressTimer.cancel();
      debugPrint('[ScanPage] unexpected error: $e');
      debugPrint('[ScanPage] stacktrace: $st');
      if (!mounted) return;
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('网络异常: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── 点击拍摄的引导背景 ─────────────────────────────────────
          _CameraBackground(isScanning: _isScanning),

          // ── 顶部工具栏 ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.home),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '请对准配料表',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleTorch,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _torchOn ? Colors.yellow : Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                        color: _torchOn ? Colors.black : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 扫描框 ─────────────────────────────────────────────────
          Center(
            child: _ScanFrame(
              scanLineAnim: _scanLineAnim,
              isScanning: _isScanning,
            ),
          ),

          // ── 右侧识别结果面板 ───────────────────────────────────────
          if (_detectedItems.isNotEmpty)
            Positioned(
              right: 16,
              top: 0,
              bottom: 100,
              width: 120,
              child: _DetectedPanel(items: _detectedItems),
            ),

          // ── 底部操作栏 ─────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomBar(
              isScanning: _isScanning,
              onGallery: _pickFromGallery,
              onCapture: _takePhoto,
              onTorch: _toggleTorch,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 相机背景模拟 ─────────────────────────────────────────────────────────────

class _CameraBackground extends StatelessWidget {
  final bool isScanning;
  const _CameraBackground({required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            isScanning
                ? const Color(0xFF1A2E1A)
                : const Color(0xFF0D1117),
            Colors.black,
          ],
        ),
      ),
      child: const Stack(
        children: [
          // 模拟食品标签文字背景
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Center(
                child: Text(
                  '生牛乳 (>80%)，乳清蛋白粉，\n白砂糖，脱脂奶粉，食品添加剂\n(羧甲基纤维素钠，柠檬酸，\n三氯蔗糖，安赛蜜)，乳酸菌。\n\n营养成分表 (每100mL)\n能量　320kJ　4%\n蛋白质　6.0g　10%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'monospace',
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 扫描框 ───────────────────────────────────────────────────────────────────

class _ScanFrame extends StatelessWidget {
  final Animation<double> scanLineAnim;
  final bool isScanning;

  const _ScanFrame({
    required this.scanLineAnim,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    const frameSize = 260.0;
    return SizedBox(
      width: frameSize,
      height: frameSize,
      child: Stack(
        children: [
          // 四角指示线
          CustomPaint(
            size: const Size(frameSize, frameSize),
            painter: _CornerPainter(
                color: isScanning ? AppColors.primaryLight : Colors.white),
          ),
          // 扫描动线
          if (isScanning)
            AnimatedBuilder(
              animation: scanLineAnim,
              builder: (context, child) {
                return Positioned(
                  top: 8 + scanLineAnim.value * (frameSize - 16),
                  left: 8,
                  right: 8,
                  height: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryLight,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryLight,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const length = 24.0;
    final corners = [
      [const Offset(0, length), const Offset(0, 0), const Offset(length, 0)],
      [
        Offset(size.width - length, 0),
        Offset(size.width, 0),
        Offset(size.width, length)
      ],
      [
        Offset(size.width, size.height - length),
        Offset(size.width, size.height),
        Offset(size.width - length, size.height)
      ],
      [
        Offset(length, size.height),
        Offset(0, size.height),
        Offset(0, size.height - length)
      ],
    ];

    for (final pts in corners) {
      final path = Path()
        ..moveTo(pts[0].dx, pts[0].dy)
        ..lineTo(pts[1].dx, pts[1].dy)
        ..lineTo(pts[2].dx, pts[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.color != color;
}

// ── 右侧识别结果面板 ─────────────────────────────────────────────────────────

class _DetectedPanel extends StatelessWidget {
  final List<String> items;
  const _DetectedPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.primaryLight, size: 12),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ── 底部操作栏 ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onTorch;

  const _BottomBar({
    required this.isScanning,
    required this.onGallery,
    required this.onCapture,
    required this.onTorch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 相册
          _BarButton(
            icon: Icons.photo_library_outlined,
            label: '相册',
            onTap: onGallery,
          ),
          // 识别按钮（主按钮）
          GestureDetector(
            onTap: isScanning ? null : onCapture,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isScanning ? Colors.white24 : Colors.white,
                border: Border.all(
                    color: AppColors.primaryLight, width: 3),
              ),
              child: isScanning
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    )
                  : const Icon(Icons.camera_alt,
                      color: AppColors.primary, size: 30),
            ),
          ),
          // 手电筒
          _BarButton(
            icon: Icons.flashlight_on_outlined,
            label: '手电筒',
            onTap: onTorch,
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
