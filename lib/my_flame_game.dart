import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_game/levels/actors_level.dart';
import 'package:flame_game/levels/level.dart';
import 'package:flutter/material.dart';

class MyFlameGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 33, 31, 49);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(
      actorsList: actorsLevelList,
    );

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 35, bottom: 35),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
        playerLevel.horizontalMovement = -1;
        break;

      case JoystickDirection.upLeft:
        playerLevel.horizontalMovement = -1;
        playerLevel.hasJump = true;
        break;
      case JoystickDirection.upRight:
        playerLevel.horizontalMovement = 1;
        playerLevel.hasJump = true;
        break;

      case JoystickDirection.right:
      case JoystickDirection.downRight:
        playerLevel.horizontalMovement = 1;
        break;

      case JoystickDirection.up:
        playerLevel.hasJump = true;
        break;

      default:
        playerLevel.hasJump = false;
        playerLevel.horizontalMovement = 0;
        break;
    }
  }
}
