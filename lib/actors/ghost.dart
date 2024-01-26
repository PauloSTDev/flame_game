import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game/my_flame_game.dart';

enum GhostState { idle, appears, vanish }

class Ghost extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame> {
  Ghost({
    position,
    required this.textureSize,
  }) : super(position: position, current: GhostState.appears);

  Vector2 textureSize;

  int amountIdle = 7;
  double stepTimeIdle = 0.15;

  int amountAppears = 6;
  double stepTimeAppears = 0.10;

  int amountVanish = 7;
  double stepTimeVanish = 0.10;

  late SpriteAnimation animationIdle;
  late SpriteAnimation animationAppears;
  late SpriteAnimation animationVanish;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => current = GhostState.idle,
    );
    super.update(dt);
  }

  void _loadAnimations() {
    animationIdle = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('character/ghost/ghost_idle.png'),
      SpriteAnimationData.sequenced(
        amount: amountIdle,
        textureSize: textureSize,
        stepTime: stepTimeIdle,
      ),
    );

    animationAppears = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('character/ghost/ghost_appears.png'),
      SpriteAnimationData.sequenced(
        amount: amountAppears,
        stepTime: stepTimeAppears,
        textureSize: textureSize,
      ),
    );

    animationVanish = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('character/ghost/ghost_vanish.png'),
      SpriteAnimationData.sequenced(
        amount: amountVanish,
        textureSize: textureSize,
        stepTime: stepTimeVanish,
      ),
    );

    animations = {
      GhostState.idle: animationIdle,
      GhostState.appears: animationAppears,
      GhostState.vanish: animationVanish,
    };
  }
}
