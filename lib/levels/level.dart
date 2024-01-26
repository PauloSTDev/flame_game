import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_game/components/collision_block.dart';
import 'package:flame_game/components/items/fire/fire.dart';
import 'package:flame_game/components/items/fire/fire_list.dart';
import 'package:flame_game/components/items/fire_skull/fire_skull.dart';

import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  final Player player;
  final FireSkull fireSkull;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.player, required this.fireSkull});
  final List<Fire> spawnFiresList = firesList;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01_new.tmx', Vector2.all(16));

    _addCollisions();
    _spawingFire();
    add(level);
    add(player);
    add(fireSkull);

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
    player.collisionBlocks = collisionBlocks;
  }

  void _spawingFire() {
    addAll(spawnFiresList);
  }
}
