import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:agrosat/bloc/bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agrosat/models/field_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  CameraPosition cameraPos = const CameraPosition(
    target: LatLng(53, 16),
    zoom: 4,
  );
  MapType mapType = MapType.satellite;
  Set<Polygon> polygon = HashSet<Polygon>();

  Future<Field> readJson() async {
    final String response = await rootBundle.loadString('assets/field.json');
    final data = await json.decode(response);
    return Field.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white30,
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                child: Image.asset('assets/logo.png'),
              ),
              ListTile(
                title: const Text('Załaduj pole',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<MapBloc>().add(LoadField());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                    const Text('Mapa 1', style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<MapBloc>().add(ChangeMap(MapType.terrain));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                    const Text('Mapa 2', style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<MapBloc>().add(ChangeMap(MapType.satellite));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                    const Text('Mapa 3', style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<MapBloc>().add(ChangeMap(MapType.hybrid));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          top: false,
          child: BlocBuilder<MapBloc, MapState>(builder: (context, state) {
            if (state is FieldLoaded) {
              polygon.clear();
              cameraPos = CameraPosition(
                  target: LatLng(state.points.first.latitude,
                      state.points.first.longitude),
                  zoom: 14);
              polygon.add(Polygon(
                polygonId: const PolygonId('1'),
                points: state.points,
                holes: state.holes,
                fillColor: Colors.orange.withOpacity(0.5),
                strokeColor: Colors.red,
                geodesic: true,
                strokeWidth: 1,
              ));
              mapController
                  .moveCamera(CameraUpdate.newCameraPosition(cameraPos));
              return googleMap();
            } else if (state is MapChanged) {
              mapType = state.mapType;
              return googleMap();
            } else {
              return googleMap();
            }
          })),
    );
  }

  googleMap() => GoogleMap(
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        initialCameraPosition: cameraPos,
        mapType: mapType,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        polygons: polygon,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      );
}
