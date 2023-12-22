import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game/my_flame_game.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame> {
  Player({
    required this.character,
    required this.textureSize,
  });
  String character;
  Vector2 textureSize;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.2;

  @override
  FutureOr<void> onLoad() {
    _onLoadAllAnimations();

    return super.onLoad();
  }

  void _onLoadAllAnimations() {
    SpriteAnimation _createSpriteAnimation(
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

    idleAnimation = _createSpriteAnimation(
      'character/$character/idle.png',
      5,
      stepTime,
    );

    runningAnimation = _createSpriteAnimation(
      'character/$character/run.png',
      8,
      0.10,
    );

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.idle;
  }
}
