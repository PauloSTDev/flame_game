import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/custom_hitbox.dart';
import 'package:flame_game/my_flame_game.dart';

enum FireState { idle, extinguished }

class Fire extends SpriteAnimationGroupComponent with HasGameRef<MyFlameGame>, CollisionCallbacks {
  Fire({
    position,
    required this.fireStates,
    required this.textureSize,
    this.color = 'blue',
  }) : super(position: position, current: fireStates);

  FireState fireStates;
  String color;
  Vector2 textureSize;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 4,
    offsetY: 12,
    width: 16,
    height: 20,
  );

  late SpriteAnimation idleAnimation;
  late SpriteAnimation extinguishedAnimation;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        // collisionType: CollisionType.passive,
      ),
    );
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
