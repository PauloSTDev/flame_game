import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game/my_flame_game.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame>, KeyboardHandler {
  Player({
    position,
    required this.character,
    required this.textureSize,
    required this.amountIdle,
    required this.amountRun,
    required this.stepTimeIdle,
    required this.stepTimeRun,
    required this.playerState,
  }) : super(position: position);

  String character;
  Vector2 textureSize;
  int amountIdle;
  int amountRun;
  double stepTimeIdle;
  double stepTimeRun;
  PlayerState playerState;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final goToLeft =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final goToRight =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);

    if (goToLeft && goToRight) {
      playerDirection = PlayerDirection.none;
    } else if (goToLeft) {
      playerDirection = PlayerDirection.left;
    } else if (goToRight) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _onLoadAllAnimations() {
    SpriteAnimation createSpriteAnimation(
      String path,
      int amount,
      double stepTime,
    ) {
      return SpriteAnimation.fromFrameData(
        game.images.fromCache(path),
        SpriteAnimationData.sequenced(
          amount: amount,
          textureSize: textureSize,
          stepTime: stepTime,
        ),
      );
    }

    idleAnimation = createSpriteAnimation(
      'character/$character/idle.png',
      amountIdle,
      stepTimeIdle,
    );

    runningAnimation = createSpriteAnimation(
      'character/$character/run.png',
      amountRun,
      stepTimeRun,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      default:
        current = PlayerState.idle;
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
