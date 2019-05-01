import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'page.dart';

import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';


class FireMapPage extends Page {
  FireMapPage() : super(const Icon(Icons.map), 'FireMap');

  @override
  Widget build(BuildContext context) {
    return const FireMap();
  }
}

class FireMap extends StatefulWidget {
  const FireMap();

  @override
  State createState() => FireMapState();

}

class FireMapState extends State<FireMap> {

  GoogleMapController mapController;
  Location location = new Location();

  _animateToUser() async {
    var pos = await location.getLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos['latitude'], pos['longitude']),
          zoom: 17.0,
        )
    )
    );
  }

  @override
  void initState(){
    super.initState();
  }



  build(context) {
    return Stack(children:[
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom:15
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        mapType: MapType.normal
      )
      Positioned(
        bottom: 50,
        right: 10,
        child:
          FlatButton(
            child: Icon(Icon.pin_drop, color: Colors.white),
            color: Colors.green,
            onPressed: _addMarker,
          )
      )
    ],);
  }
}
//
//_onMapCreated(GoogleMapController controller) {
//  setState(() {
//    mapController = controller;
//  });
//}

_addMarker(){
  var marker = MarkerOptions(
    position: mapController.cameraposition.target,
    icon: BitmapDescriptor.defaultMarker,
    infoWindowText: InfoWindowText('Marker', 'There is an event here'),
  );

  mapController.addMarker(marker);
}

