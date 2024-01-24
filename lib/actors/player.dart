import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/collision_block.dart';
import 'package:flame_game/components/custom_hitbox.dart';
import 'package:flame_game/components/fire.dart';
import 'package:flame_game/components/utils.dart';
import 'package:flame_game/my_flame_game.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame>, KeyboardHandler, CollisionCallbacks {
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
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  final double _gravity = 9.0;
  final double _jumpForce = 260.0;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJump = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 14,
    offsetY: 10,
    width: 22,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();
    // debugMode = true;
    add(RectangleHitbox(
      position: Vector2(
        hitbox.offsetX,
        hitbox.offsetY,
      ),
      size: Vector2(hitbox.width, hitbox.height),
    ));
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

    horizontalMovement += goToLeft ? -1 : 0;
    horizontalMovement += goToRight ? 1 : 0;

    hasJump = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fire) other.collidedWithPlayer();
    super.onCollision(intersectionPoints, other);
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
    jumpingAnimation = createSpriteAnimation(
      'character/$character/attack.png',
      2,
      0.8,
    );
    fallingAnimation = createSpriteAnimation(
      'character/$character/idle.png',
      2,
      0.8,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJump && isOnGround) _playerJump(dt);
    if (velocity.y > _gravity) isOnGround = false;
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

    if (velocity.x > 0 || velocity.x < 0 && !isOnGround) playerState = PlayerState.running;

    if (velocity.y < 0) playerState = PlayerState.jumping;

    if (velocity.y > 0) playerState = PlayerState.falling;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.x > 0) {
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
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
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }
}
