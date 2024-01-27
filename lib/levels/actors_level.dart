import 'package:flame/components.dart';
import 'package:flame_game/actors/ghost.dart';
import 'package:flame_game/actors/player.dart';
import 'package:flame_game/components/items/fire_skull/fire_skull.dart';

final List<SpriteAnimationGroupComponent> actorsLevelList = [
  playerLevel,
  // fireSkullLevel,
  ghostLevel,
];

Player playerLevel = Player(
  textureSize: Vector2(48, 38),
  position: Vector2(80, 282),
  amountIdle: 5,
  amountRun: 8,
  stepTimeIdle: 0.2,
  stepTimeRun: 0.10,
  playerState: PlayerState.idle,
);

FireSkull fireSkullLevel = FireSkull(
  position: Vector2(15, 30),
);

Ghost ghostLevel = Ghost(
  position: Vector2(270, 220),
  textureSize: Vector2(64, 64),
);
