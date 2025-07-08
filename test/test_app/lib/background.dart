import 'package:flutter/material.dart';
import 'widget/cat.dart';

// main.dart'

class ImageContent extends StatefulWidget {
  const ImageContent({super.key});

  @override
  State<ImageContent> createState() => _ImageContentState();
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // 取消預設的 overscroll（拉扯或陰影效果）
  }
}

class _ImageContentState extends State<ImageContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenHeight = MediaQuery.of(context).size.height;
      final imageWidth = screenHeight * 1.6875;
      final screenWidth = MediaQuery.of(context).size.width;
      final scrollTo = (imageWidth - screenWidth) / 2;
      _scrollController.jumpTo(scrollTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = screenHeight * 1.6875;

    return Center(
      child: ScrollConfiguration(
        behavior: const NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(), // 禁止彈性
          child: SizedBox(
            height: screenHeight,
            width: imageWidth,
            child: Stack(
              children: [
                Image.asset(
                  'assets/1.PNG',
                  fit: BoxFit.cover,
                  height: screenHeight,
                  width: imageWidth,
                ),
                const CatWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
