import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game/components/collision_block.dart';
import 'package:flame_game/components/utils.dart';
import 'package:flame_game/my_flame_game.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame>, KeyboardHandler {
  Player({
    position,
    this.character = 'reaper',
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

  final double _gravity = 9.0;
  final double _jumpForce = 260.0;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJump = false;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState();
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final goToLeft =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final goToRight =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);

    // if (goToLeft && goToRight) {
    //   playerDirection = PlayerDirection.none;
    // } else if (goToLeft) {
    //   playerDirection = PlayerDirection.left;
    // } else if (goToRight) {
    //   playerDirection = PlayerDirection.right;
    // } else {
    //   playerDirection = PlayerDirection.none;
    // }

    horizontalMovement += goToLeft ? -1 : 0;
    horizontalMovement += goToRight ? 1 : 0;

    hasJump = keysPressed.contains(LogicalKeyboardKey.arrowUp);

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
    if (hasJump && isOnGround) _playerJump(dt);
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJump = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.x > 0) {
            position.x = block.x - width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
      } else {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - (width - 10);
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
            break;
          }
        }
      }
    }
  }
}
