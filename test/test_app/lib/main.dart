// main.dart
import 'package:flutter/material.dart';
import 'background.dart';
import 'overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageViewer(),
    );
  }
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool _showOverlay = true;

  void _hideOverlay() {
    setState(() {
      _showOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ImageContent(), // 背景圖片
          if (_showOverlay) StartOverlay(onDismiss: _hideOverlay), // 遮罩動畫
        ],
      ),
    );
  }
}
