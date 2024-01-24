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
  bool _collected = false;
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
    // debugMode = true;
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
      String animationType,
    ) {
      return SpriteAnimation.fromFrameData(
        game.images.fromCache('fires/$animationType/${color}_$animationType.png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          textureSize: textureSize,
          stepTime: stepTime,
        ),
      );
    }

    idleAnimation = createSpriteAnimation(color, 8, 0.15, 'loops');
    extinguishedAnimation = createSpriteAnimation(color, 5, 0.15, 'end');

    animations = {
      FireState.idle: idleAnimation,
      FireState.extinguished: extinguishedAnimation,
    };
  }

  void collidedWithPlayer() {
    if (!_collected) {
      current = FireState.extinguished;
      _collected = true;
    }
    Future.delayed(const Duration(milliseconds: 700), () {
      // Faz a chama desaparecer que chamou essa função desaparecer
      removeFromParent();
    });
  }
}
