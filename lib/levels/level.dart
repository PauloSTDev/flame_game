import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;
  final Player player;

  Level({required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));

    add(level);
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

    add(player);

    return super.onLoad();
  }
}
