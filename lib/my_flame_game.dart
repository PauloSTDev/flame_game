import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_game/levels/level.dart';
import 'package:flutter/material.dart';

class MyFlameGame extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 33, 31, 49);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  bool showJoystick = true;

  Player player = Player(
    textureSize: Vector2(48, 38),
    position: Vector2(80, 282),
    amountIdle: 5,
    amountRun: 8,
    stepTimeIdle: 0.2,
    stepTimeRun: 0.10,
    playerState: PlayerState.idle,
  );

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(
      player: player,
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
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      default:
        //idle
        player.horizontalMovement = 0;
        break;
    }
  }
}
