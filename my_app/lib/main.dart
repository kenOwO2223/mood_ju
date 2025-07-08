import 'package:flutter/material.dart';
import 'screens/room_screen.dart';

void main() {
  runApp(RoomApp());
}

class RoomApp extends StatelessWidget {
  const RoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '沉浸式房間',
      home: RoomScreen(),
    );
  }
}
