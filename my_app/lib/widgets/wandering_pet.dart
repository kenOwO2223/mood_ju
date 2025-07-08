import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pet_status.dart';
import 'pet_action_menu.dart';
import 'chat_interface.dart';

class WanderingPet extends StatefulWidget {
  const WanderingPet({super.key});

  @override
  State<WanderingPet> createState() => _WanderingPetState();
}

class _WanderingPetState extends State<WanderingPet> {
  double _leftPosition = 100;
  double _bottomPosition = 80;
  final double _jumpOffset = 0;
  final bool _isJumping = false;
  bool _isIdle = false;
  bool _menuOpen = false;
  bool _isDragging = false;

  final Random _random = Random();
  final PetStatus _status = PetStatus();

  late Timer _wanderTimer;
  late Timer _decayTimer;

  late Offset _dragStartOffset;
  late double _dragStartLeft;
  late double _dragStartBottom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWandering();
      _startDecay();
    });
  }

  void _startWandering() {
    _wanderTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_isJumping || _isIdle || _menuOpen || _isDragging) return;

      if (_random.nextDouble() < 0.3) {
        _isIdle = true;
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) setState(() => _isIdle = false);
        });
        return;
      }

      double moveX = (_random.nextBool() ? 1 : -1) * (20.0 + _random.nextInt(60));
      double moveY = (_random.nextBool() ? 1 : -1) * (10.0 + _random.nextInt(30));

      final screenSize = MediaQuery.of(context).size;
      final maxLeft = screenSize.width - 100;
      final maxBottom = screenSize.height - 600;

      setState(() {
        _leftPosition = (_leftPosition + moveX).clamp(0, maxLeft);
        _bottomPosition = (_bottomPosition + moveY).clamp(100, maxBottom);
      });
    });
  }

  void _startDecay() {
    _decayTimer = Timer.periodic(Duration(seconds: 10), (_) {
      setState(() {
        _status.decreaseHunger(1);
        _status.decreaseActivity(1);
      });
    });
  }

  void _showPettingReaction() {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: _leftPosition + 50,
        bottom: _bottomPosition + 100,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
          child: Text(
            '好舒服！',
            style: TextStyle(fontSize: 18, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(Duration(seconds: 1), () => entry.remove());
  }

  void _showStatusDialog() {

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('寵物狀態'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👑 親密度等級：Lv.${_status.intimacyLevel}'),
              Text('🍗 飽食度：${_status.hunger} / 100'),
              Text('🏃 活躍值：${_status.activity} / 100'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('關閉'),
            )
          ],
        );
      },
    );
  }

  void _showActionMenu() {
  _wanderTimer.cancel();
  setState(() => _menuOpen = true);

  final screenWidth = MediaQuery.of(context).size.width;
  final isNearRightEdge = _leftPosition + 160 > screenWidth;
  final menuX = isNearRightEdge ? _leftPosition - 120 : _leftPosition + 60;

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return Stack(
        children: [
          Positioned(
            left: menuX,
            bottom: _bottomPosition + _jumpOffset + 40,
            child: PetActionMenu(
              isLeftSide: isNearRightEdge,
              onStatus: () {
                Navigator.pop(dialogContext);
                _showStatusDialog();
              },
              onFeed: () {
                setState(() {
                  _status.hunger = (_status.hunger + 15).clamp(0, 100);
                  _status.increaseIntimacy();
                });
                Navigator.pop(dialogContext);
              },
              onPet: () {
                setState(() {
                  _status.increaseIntimacy();
                });
                _showPettingReaction();
                Navigator.pop(dialogContext);
              },
              onChat: () {
                print('對話按鈕被點擊，正在開啟對話框...'); // 用來驗證是否有觸發
                Navigator.pop(dialogContext);
                _showChatDialog();
              },
            ),
          ),
        ],
      );
    },
  ).then((_) {
    _startWandering();
    setState(() => _menuOpen = false);
  });
}


  void _showChatDialog() {
    print('對話按鈕被點擊，正在開啟對話框...');
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chat Dialog', 
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: ChatInterface(),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _wanderTimer.cancel();
    _decayTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: _isJumping ? 150 : 1000),
      bottom: _bottomPosition + _jumpOffset,
      left: _leftPosition,
      child: GestureDetector(
        onPanStart: (details) {
          _isDragging = true;
          _dragStartOffset = details.globalPosition;
          _dragStartLeft = _leftPosition;
          _dragStartBottom = _bottomPosition;
        },
        onPanUpdate: (details) {
          final dx = details.globalPosition.dx - _dragStartOffset.dx;
          final dy = details.globalPosition.dy - _dragStartOffset.dy;

          final screenSize = MediaQuery.of(context).size;
          final newLeft = (_dragStartLeft + dx).clamp(0, screenSize.width - 100).toDouble();
          final newBottom = (_dragStartBottom - dy).clamp(100, screenSize.height - 200).toDouble();

          setState(() {
            _leftPosition = newLeft;
            _bottomPosition = newBottom;
          });
        },
        onPanEnd: (_) {
          _isDragging = false;
        },
        onTap: _showActionMenu,
        child: Image.asset(
          'assets/pet_idle.png',
          width: 100,
        ),
      ),
    );
  }
}
