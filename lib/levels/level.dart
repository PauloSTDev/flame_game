import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_game/components/collision_block.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];

  Level({required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01_new.tmx', Vector2.all(16));

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

    add(level);
    add(player);
    // final playerSkeleton = Player(
    //   character: 'skeleton',
    //   textureSize: Vector2(22, 100),
    //   position: Vector2(110, 288),
    //   amountIdle: 11,
    //   amountRun: 13,
    //   stepTimeIdle: 0.2,
    //   stepTimeRun: 0.05,
    //   playerState: PlayerState.running,
    // );

    return super.onLoad();
  }
}
