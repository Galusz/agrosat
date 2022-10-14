part of 'bloc_bloc.dart';

@immutable
abstract class MapEvent {}

class LoadField extends MapEvent {}

class ChangeMap extends MapEvent {
  final MapType mapType;

  ChangeMap(this.mapType);
}
