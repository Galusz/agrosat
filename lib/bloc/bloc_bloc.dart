import 'dart:convert';
import 'package:agrosat/models/field_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'bloc_event.dart';

part 'bloc_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadField>((event, emit) async {
      List<LatLng> points = [];
      List<List<LatLng>> holes = [];
      final String response = await rootBundle.loadString('assets/field.json');
      final data = await json.decode(response);
      final re = RegExp(r"\((.*?)\)");
      Iterable<Match> matches = re.allMatches(data['geom'], 0);
      bool isHole = false;
      for (final Match m in matches) {
        String match = m[0]!;
        var list =
            match.replaceAll('(', '').replaceAll(')', '').trim().split(',');
        List<LatLng> tempPoints = [];
        for (final String s in list) {
          var p = s.trimLeft().split(' ');
          tempPoints.add(LatLng(double.parse(p.last), double.parse(p.first)));
        }
        if (isHole) {
          holes.add(tempPoints);
        } else {
          isHole = true;
          points.addAll(tempPoints);
        }
      }
      emit(FieldLoaded(
          field: Field.fromJson(data), points: points, holes: holes));
    });

    on<ChangeMap>((event, emit) async {
      emit(MapChanged(mapType: event.mapType));
    });
  }
}
