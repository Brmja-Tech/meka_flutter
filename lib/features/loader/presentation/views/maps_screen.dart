import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  // late GoogleMapController _controller;
  // final LatLng _center = const LatLng(37.42796133580664, -122.085749655962);
  //
  // // Markers
  // Set<Marker> _markers = {};
  //
  // // Function to handle map creation
  // void _onMapCreated(GoogleMapController controller) {
  //   _controller = controller;
  //   setState(() {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId('some_marker'),
  //         position: _center,
  //         infoWindow: InfoWindow(
  //           title: 'Marker Title',
  //           snippet: 'Marker Description',
  //         ),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
