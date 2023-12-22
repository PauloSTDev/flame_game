import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/my_flame_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  MyFlameGame game = MyFlameGame();
  runApp(GameWidget(game: kDebugMode ? MyFlameGame() : game));
}
