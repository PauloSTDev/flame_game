import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/my_flame_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  MyFlameGame game = MyFlameGame();
  runApp(GameWidget(game: kDebugMode ? MyFlameGame() : game));
}
