import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_game/levels/level.dart';
import 'package:flutter/material.dart';

class MyFlameGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 156, 174, 237);

  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    return super.onLoad();
  }
}
