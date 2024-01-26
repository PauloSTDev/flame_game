import 'package:flame/components.dart';
import 'package:flame_game/components/items/fire/fire.dart';

final _size = Vector2(24, 32);

final firesList = [
  Fire(
    fireStates: FireState.idle,
    position: Vector2(51, 192),
    textureSize: _size,
    color: 'white',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(107, 129),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(234, 129),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(444, 129),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(530, 177),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(555, 129),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(555, 81),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(348, 97),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(530, 288),
    textureSize: _size,
    color: 'green',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(245, 288),
    textureSize: _size,
    color: 'green',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(188, 224),
    textureSize: _size,
    color: 'orange',
  ),
  Fire(
    fireStates: FireState.idle,
    position: Vector2(205, 224),
    textureSize: _size,
    color: 'orange',
  ),
];
