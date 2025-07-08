import 'package:flutter/material.dart';

class PetActionMenu extends StatelessWidget {
  final VoidCallback onStatus;
  final VoidCallback onFeed;
  final VoidCallback onPet;
  final bool isLeftSide; // 新增參數：圖標是否要放在寵物左側

  const PetActionMenu({
    Key? key,
    required this.onStatus,
    required this.onFeed,
    required this.onPet,
    this.isLeftSide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 若在左邊，所有偏移量的 x 反向
    final offsetMultiplier = /*isLeftSide ? -1.0 */ 1.0;

    return SizedBox(
      width: 150,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildActionButton(
            icon: Icons.favorite,
            label: '狀態',
            offset: Offset(offsetMultiplier * -15, 60),
            onTap: onStatus,
          ),
          _buildActionButton(
            icon: Icons.fastfood,
            label: '餵食',
            offset: Offset(offsetMultiplier * 25, 100),
            onTap: onFeed,
          ),
          _buildActionButton(
            icon: Icons.touch_app,
            label: '撫摸',
            offset: Offset(offsetMultiplier * -15, 140),
            onTap: onPet,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Offset offset,
    required VoidCallback onTap,
  }) {
    return Transform.translate(
      offset: offset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: label,
            mini: true,
            onPressed: onTap,
            child: Icon(icon),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
