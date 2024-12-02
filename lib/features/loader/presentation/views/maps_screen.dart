import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';
import 'package:meka/features/loader/presentation/blocs/loader_state.dart';
import 'package:meka/features/loader/presentation/widgets/trip_bottom_sheet.dart';
import 'package:meka/service_locator/service_locator.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final location.Location _location = location.Location();
  LatLng? _currentPosition;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  String? currentAddress;

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.locality}, ${place.administrativeArea}';
      });
    } catch (e) {
      print('Failed to get address: $e');
      setState(() {
        currentAddress = 'Unknown location';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      location.PermissionStatus permissionGranted =
          await _location.hasPermission();
      if (permissionGranted == location.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != location.PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      // Move the camera to the current location once initialized

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    } catch (e) {
      // Handle errors like location services being disabled
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderBloc, LoaderState>(builder: (context, state) {
      log('polyline is ${state.polylines}');
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? const LatLng(30, 30),
              // Default location
              zoom: 14,
            ),
            polylines: state.polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              if (state.coordinate != null)
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(state.coordinate!.latitude,
                      state.coordinate!.longitude),
                ),
            },
            myLocationEnabled: true,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 140.0.h),
            child: CustomElevatedButton(
              text: 'اطلب الان',
              onPressed: () async {

                await _checkLocationAndProceed(context);
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              height: 80.h,
              width: MediaQuery.of(context).size.width - 80.w,
            ),
          )
        ],
      );
    });
  }


  Future<void> _checkLocationAndProceed(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          context.showErrorMessage('Please enable location services to continue.');
          return;
        }
      }

      // Check for location permissions
      location.PermissionStatus permissionGranted =
      await _location.hasPermission();
      if (permissionGranted == location.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != location.PermissionStatus.granted) {
          context.showErrorMessage('Location permissions are denied.');
          return;
        }
      }

      // Get current location
      final locationData = await _location.getLocation();
      setState(() {
        _currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      log('Origin is ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      await _getAddressFromLatLng();
      if(context.mounted) {
      context.read<LoaderBloc>().resetState();
        showTripBottomSheet(
        context,
        currentAddress ?? '',
        _currentPosition == null
            ? ''
            : '${_currentPosition!.latitude},${_currentPosition!.longitude}',
      );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
