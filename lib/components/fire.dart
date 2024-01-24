import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_game/my_flame_game.dart';

enum FireState { idle, extinguished }

class Fire extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame> {
  Fire({
    position,
    required this.fireStates,
    required this.textureSize,
    this.color = 'blue',
  }) : super(position: position, current: fireStates);

  FireState fireStates;
  String color;
  Vector2 textureSize;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation extinguishedAnimation;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    priority = -1;
    _onLoadAllAnimations();
    return super.onLoad();
  }

  void _onLoadAllAnimations() {
    SpriteAnimation createSpriteAnimation(
      String color,
      int amount,
      double stepTime,
    ) {
      return SpriteAnimation.fromFrameData(
        game.images.fromCache('fires/loops/${color}_loops.png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          textureSize: textureSize,
          stepTime: stepTime,
        ),
      );
    }

    idleAnimation = createSpriteAnimation(color, 8, 0.15);
    extinguishedAnimation = createSpriteAnimation(color, 5, 0.15);

    animations = {
      FireState.idle: idleAnimation,
      FireState.extinguished: extinguishedAnimation,
    };
  }
}
