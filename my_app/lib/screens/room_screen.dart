import 'package:flutter/material.dart';
import '../widgets/wandering_pet.dart';

class RoomScreen extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 1);

  RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          RoomScene(scene: 'left', background: 'assets/room_left.jpg'),
          RoomScene(scene: 'center', background: 'assets/room_center.jpg'),
          RoomScene(scene: 'right', background: 'assets/room_right.jpg'),
        ],
      ),
    );
  }
}

class RoomScene extends StatelessWidget {
  final String scene;
  final String background;

  const RoomScene({super.key, required this.scene, required this.background});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(background, fit: BoxFit.cover),
        ),
        if (scene == 'center') WanderingPet(),
        if (scene == 'center')
          Positioned(
            bottom: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('寫日記'),
            ),
          ),
      ],
    );
  }
}
