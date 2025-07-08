import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'menu.dart';
import 'pet_status.dart';

int catWidth = 400;

enum CatState { loopingA, playingAB, playingBC, loopingC }

class CatWidget extends StatefulWidget {
  const CatWidget({super.key});

  @override
  State<CatWidget> createState() => _CatWidgetState();
}

class _CatWidgetState extends State<CatWidget> with TickerProviderStateMixin {
  final Map<CatState, String> _gifPaths = {
    CatState.loopingA: 'assets/A.gif',
    CatState.playingAB: 'assets/AB.gif',
    CatState.playingBC: 'assets/BC.gif',
    CatState.loopingC: 'assets/C.gif',
  };

  final Map<CatState, GifController> _controllers = {};
  late CatState _currentState;
  late GifController _gifController;

  final PetStatus _status = PetStatus();
  final Duration _abDuration = const Duration(seconds: 3);
  final Duration _bcDuration = const Duration(seconds: 2);
  final Duration _loopDuration = const Duration(seconds: 1);

  bool _showMenu = false;
  late AnimationController _menuAnimController;
  late Animation<Offset> _menuOffset;

  double _offsetX = 0.0;
  double cat_X = 0.0;
  double cat_Y = 110;

  @override
  void initState() {
    super.initState();
    _currentState = CatState.loopingA;

    for (var state in CatState.values) {
      _controllers[state] = GifController(vsync: this);
    }
    _gifController = _controllers[_currentState]!;

    _controllers[CatState.loopingA]!.repeat(
      min: 0,
      max: 29,
      period: _loopDuration,
    );

    _menuAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _menuOffset = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _menuAnimController, curve: Curves.easeOut),
    );
  }

  void _startAnimation(CatState state, Duration duration, VoidCallback onComplete) {
    _gifController = _controllers[state]!;
    _gifController.reset();
    _gifController.animateTo(29, duration: duration);
    Future.delayed(duration, onComplete);
  }

  void _handleCatClick() {
    if (_currentState == CatState.loopingA) {
      _controllers[_currentState]!.stop();

      setState(() => _currentState = CatState.playingAB);
      _startAnimation(CatState.playingAB, _abDuration, () {
        if (!mounted) return;
        setState(() => _currentState = CatState.playingBC);
        _startAnimation(CatState.playingBC, _bcDuration, () {
          if (!mounted) return;
          setState(() {
            _currentState = CatState.loopingC;
            _gifController = _controllers[_currentState]!;
            _gifController.repeat(min: 0, max: 29, period: _loopDuration);
          });
        });
      });
    } else {
      _showActionMenu();
    }
  }

  void _showActionMenu() {
    setState(() => _showMenu = true);
    _menuAnimController.forward(from: 0);
  }

  void _hideActionMenu() {
    setState(() => _showMenu = false);
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('寵物狀態'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('👑 親密度等級：Lv.${_status.intimacyLevel}'),
            Text('🍗 飽食度：${_status.hunger} / 100'),
            Text('🏃 活躍值：${_status.activity} / 100'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  void _showPettingReaction() {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: cat_X,
        bottom: cat_Y + 80,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 800),
          child: const Text(
            '好舒服！',
            style: TextStyle(
              fontSize: 18,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), () => entry.remove());
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _menuAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = screenHeight * 1.6875;

    cat_X = (imageWidth - screenWidth) / 2 + screenWidth / 2 - catWidth / 2 + _offsetX;

    return Stack(
      children: [
        Positioned(
          left: cat_X,
          bottom: cat_Y,
          child: GestureDetector(
            onTap: _handleCatClick,
            child: Stack(
              children: [
                for (var state in CatState.values)
                  Opacity(
                    opacity: state == _currentState ? 1.0 : 0.0,
                    child: Image.asset(
                      _gifPaths[state]!,
                      width: catWidth.toDouble(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_showMenu)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideActionMenu,
              child: const SizedBox.shrink(),
            ),
          ),
        if (_showMenu)
          Positioned(
            left: cat_X - 30,
            bottom: cat_Y + 80,
            child: SlideTransition(
              position: _menuOffset,
              child: AnimatedOpacity(
                opacity: _showMenu ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: PetActionMenu(
                  isLeftSide: true,
                  onStatus: () {
                    _hideActionMenu();
                    _showStatusDialog();
                  },
                  onFeed: () {
                    setState(() {
                      _status.hunger = (_status.hunger + 15).clamp(0, 100);
                      _status.increaseIntimacy();
                    });
                    _hideActionMenu();
                  },
                  onPet: () {
                    setState(() => _status.increaseIntimacy());
                    _showPettingReaction();
                    _hideActionMenu();
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
