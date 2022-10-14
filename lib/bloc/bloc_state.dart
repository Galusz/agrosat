part of 'bloc_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class FieldLoaded extends MapState {
  final Field field;
  final List<LatLng> points;
  final List<List<LatLng>> holes;

  FieldLoaded({required this.field, required this.points, required this.holes});
}

class MapChanged extends MapState {
  final MapType mapType;

  MapChanged({required this.mapType});
}
