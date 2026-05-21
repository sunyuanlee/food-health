import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/food_provider.dart';
import '../../core/router/app_router.dart';
import '../../core/data/mock_food_data.dart';
import '../../models/ingredient_model.dart';

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

  CameraController? _cameraController;
  bool _cameraReady = false;
  String? _cameraError;

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
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = '未找到可用摄像头');
        return;
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraController = controller;
        _cameraReady = true;
      });
    } catch (e) {
      setState(() => _cameraError = '摄像头初始化失败: $e');
    }
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      _startMockAnalysis();
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraReady && _cameraController != null) {
      try {
        await _cameraController!.takePicture();
      } catch (_) {}
      _startMockAnalysis();
    } else {
      // 降级：调起系统相机
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null && mounted) _startMockAnalysis();
    }
  }

  Future<void> _toggleTorch() async {
    if (_cameraReady && _cameraController != null) {
      final next = !_torchOn;
      await _cameraController!.setFlashMode(
        next ? FlashMode.torch : FlashMode.off,
      );
      setState(() => _torchOn = next);
    }
  }

  void _startMockAnalysis() {
    setState(() {
      _isScanning = true;
      _detectedItems = [];
    });

    // 模拟逐步识别成分
    final mockItems = ['生牛乳 (>80%)', '乳清蛋白粉', '白砂糖', '赤藓糖醇', '麦芽糊精', '乳酸菌'];
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (i < mockItems.length) {
        setState(() => _detectedItems.add(mockItems[i]));
        i++;
      } else {
        timer.cancel();
        _finishAnalysis();
      }
    });
  }

  void _finishAnalysis() async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final analysis = MockFoodData.analysisHistory.first;
    ref.read(analysisHistoryProvider.notifier).addAnalysis(analysis);
    context.push(AppRoutes.analysisResult, extra: analysis);

    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── 真实相机预览 ──────────────────────────────────────────
          if (_cameraReady && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else if (_cameraError != null)
            Center(
              child: Text(_cameraError!,
                  style: const TextStyle(color: Colors.white)),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

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
