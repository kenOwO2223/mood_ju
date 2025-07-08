import 'dart:math';
import 'package:flutter/material.dart';

class PetActionMenu extends StatelessWidget {
  final VoidCallback onStatus;
  final VoidCallback onFeed;
  final VoidCallback onPet;
  final VoidCallback onChat;
  final bool isLeftSide;

  const PetActionMenu({
    super.key,
    required this.onStatus,
    required this.onFeed,
    required this.onPet,
    required this.onChat,
    this.isLeftSide = false,
  });

  @override
  Widget build(BuildContext context) {
    print('PetActionMenu 建立中...');
    final offsetMultiplier = isLeftSide ? -1.0 : 1.0;

    final angles = [-90, -30, 30, 90]; // 四個按鈕的角度（半圓形）
    final radius = 80.0;

    final labels = ['狀態', '餵食', '撫摸', '對話'];
    final icons = [Icons.favorite, Icons.fastfood, Icons.touch_app, Icons.chat];
    final callbacks = [onStatus, onFeed, onPet, onChat];

    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(4, (index) {
          final angleRad = angles[index] * pi / 180;
          final dx = radius * cos(angleRad) * offsetMultiplier;
          final dy = radius * sin(angleRad);
          final label = labels[index];
          final icon = icons[index];
          final callback = callbacks[index];

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: null,
                  mini: true,
                  onPressed: () {
                    print('點擊了 $label 按鈕');
                    callback();
                  },
                  child: Icon(icon),
                ),
                const SizedBox(height: 4),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
