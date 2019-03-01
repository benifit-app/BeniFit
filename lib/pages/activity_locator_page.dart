import 'package:flutter/material.dart';
import './pages/moving_markers.dart';
import './pages/esri.dart';
import './pages/home.dart';
import './pages/map_controller.dart';
import './pages/animated_map_controller.dart';
import './pages/marker_anchor.dart';
import './pages/plugin_api.dart';
import './pages/polyline.dart';
import './pages/tap_to_add.dart';
import './pages/offline_map.dart';
import './pages/on_tap.dart';
import './pages/circle.dart';
import './pages/overlay_image.dart';


Widget build(BuildContext context) {
  return new FlutterMap(
    options: new MapOptions(
      center: new LatLng(51.5, -0.09),
      zoom: 13.0,
    ),
    layers: [
      new TileLayerOptions(
        urlTemplate: "https://api.tiles.mapbox.com/v4/"
            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
        additionalOptions: {
          'accessToken': '<PUT_ACCESS_TOKEN_HERE>',
          'id': 'mapbox.streets',
        },
      ),
      new MarkerLayerOptions(
        markers: [
          new Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(51.5, -0.09),
            builder: (ctx) =>
            new Container(
              child: new FlutterLogo(),
            ),
          ),
        ],
      ),
    ],
  );
}
