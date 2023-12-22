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
    add(Player(character: 'reaper', textureSize: Vector2(48, 200)));
    // add(Player(character: 'skeleton', textureSize: Vector2(24, 100)));

    return super.onLoad();
  }
}
