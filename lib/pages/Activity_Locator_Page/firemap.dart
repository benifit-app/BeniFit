import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'page.dart';


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

  build(context) {
    return Stack(children:[
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom:15
        ),
//        onMapCreated: _onMapCreated,
//        myLocationEnabled: true,
//        mapType: MapType.normal
      )
//      Positioned(
//        bottom: 50,
//        right: 10,
//        child:
//          FlatButton(
//            child
//          )
//      )
    ],);
  }
}
//
//_onMapCreated(GoogleMapController controller) {
//  setState(() {
//    mapController = controller;
//  });
//}