import 'package:flutter/material.dart';

class StartOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const StartOverlay({super.key, required this.onDismiss});

  @override
  State<StartOverlay> createState() => _StartOverlayState();
}

class _StartOverlayState extends State<StartOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _textOpacityController;
  late final Animation<double> _textOpacity;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _textOpacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _textOpacity = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(_textOpacityController);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _textOpacityController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _opacity = 0.0;
    });
    Future.delayed(const Duration(seconds: 1), () {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _opacity,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 上方圖片貼齊
              Image.asset(
                'assets/2.png', // ← 替換成你的圖片檔名
                fit: BoxFit.contain,
                width: double.infinity,
                alignment: Alignment.topCenter,
              ),
              const Spacer(), // 撐開空間，把文字放到底部中間
              FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  '輕觸開始遊戲',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40), // 文字與底部間距
            ],
          ),
        ),
      ),
    );
  }
}
