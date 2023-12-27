import 'dart:async';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level_01.tmx', Vector2.all(16));

    add(level);

    final playerReaper = Player(
      character: 'reaper',
      textureSize: Vector2(48, 200),
      position: Vector2(60, 282),
      amountIdle: 5,
      amountRun: 8,
      stepTimeIdle: 0.2,
      stepTimeRun: 0.10,
      playerState: PlayerState.idle,
    );

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

    add(playerReaper);

    return super.onLoad();
  }
}
