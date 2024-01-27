import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_game/components/collision_block.dart';
import 'package:flame_game/components/items/fire/fire.dart';
import 'package:flame_game/components/items/fire/fire_list.dart';
import 'package:flame_game/levels/actors_level.dart';

import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  Level({
    required List<SpriteAnimationGroupComponent> actorsList,
    required this.levelCount,
  });

  final List<Fire> spawnFiresList = fireList;
  List<CollisionBlock> collisionBlocks = [];

  late TiledComponent level;
  int levelCount;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_0${levelCount}_new.tmx', Vector2.all(16));

    _addCollisions();
    _spawingFire();
    add(level);
    addAll(actorsLevelList);

    return super.onLoad();
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    playerLevel.collisionBlocks = collisionBlocks;
  }

  void _spawingFire() {
    addAll(spawnFiresList);
  }
}
