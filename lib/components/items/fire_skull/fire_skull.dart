import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game/my_flame_game.dart';

enum FireSkullState { idle, onFire }

class FireSkull extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame> {
  FireSkull({
    required Vector2 position,
  }) : super(position: position, current: FireSkullState.idle);

  final int amountIdle = 4;
  final int amountOnFire = 8;
  final double stepTimeIdle = 0.15;
  final double stepTimeOnFire = 0.15;
  final Vector2 textureSizeIdle = Vector2(52, 68);
  final Vector2 textureSizeOnFire = Vector2(96, 108);

  final int lives = 5;
  final int score = 0;

  late SpriteAnimation animationIdle;
  late SpriteAnimation animationOnFire;

  @override
  FutureOr<void> onLoad() {
    animationIdle = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('components/fire_skull/fire_skull_no_fire.png'),
      SpriteAnimationData.sequenced(
        amount: amountIdle,
        textureSize: textureSizeIdle,
        stepTime: stepTimeIdle,
      ),
    );
    animationOnFire = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('components/fire_skull/fire_skull.png'),
      SpriteAnimationData.sequenced(
        amount: amountOnFire,
        textureSize: textureSizeOnFire,
        stepTime: stepTimeOnFire,
      ),
    );

    animations = {
      FireSkullState.idle: animationIdle,
      FireSkullState.onFire: animationOnFire,
    };

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (current == FireSkullState.idle) {
      Future.delayed(
        const Duration(seconds: 1),
        () => {
          position = Vector2(0, 0),
          current = FireSkullState.onFire,
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () => {
          position = Vector2(15, 30),
          current = FireSkullState.idle,
        },
      );
    }

    super.update(dt);
  }
}
