import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';
import 'package:meka/features/loader/presentation/blocs/loader_state.dart';
import 'package:meka/features/loader/presentation/widgets/trip_bottom_sheet.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final location.Location _location = location.Location();
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  String? currentAddress;

  LatLngBounds _getBoundsFromPolyline(Polyline polyline) {
    double minLat = polyline.points.map((e) => e.latitude).reduce(min);
    double maxLat = polyline.points.map((e) => e.latitude).reduce(max);
    double minLng = polyline.points.map((e) => e.longitude).reduce(min);
    double maxLng = polyline.points.map((e) => e.longitude).reduce(max);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        context.read<LoaderBloc>().state.currentPosition!.latitude,
        context.read<LoaderBloc>().state.currentPosition!.longitude,
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

  bool _isMapInitialized = false;

  @override
  void dispose() {
    // Clear state polylines when the screen is disposed
    // context.read<LoaderBloc>().clearPolylines();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderBloc, LoaderState>(builder: (context, state) {
      logger('polyline is ${state.polylines}');
      if (_isMapInitialized && state.polylines.isNotEmpty) {
        final bounds = _getBoundsFromPolyline(state.polylines.first);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
                bounds, 50), // Padding around the bounds
          );
        });
      }

      if (_isMapInitialized) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: context.read<LoaderBloc>().state.currentPosition!,
                zoom: 14),
          ),
        );
      }
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: context.read<LoaderBloc>().state.currentPosition ??
                  const LatLng(30, 30),
              // Default location
              zoom: 14,
            ),
            polylines: state.polylines,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
                _isMapInitialized = true;
              });
            },
            markers: {
              if (state.coordinate != null)
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(
                      state.coordinate!.latitude, state.coordinate!.longitude),
                ),
            },
            myLocationEnabled: true,
          ),
          if (state.distance != '0')
            Positioned(
                top: 50,
                child: Container(
                  width: 100,
                  // height: 200,
                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 50.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Center(
                        child: Text(
                      '${state.distance} KM',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                )),
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
          context
              .showErrorMessage('Please enable location services to continue.');
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
      // final locationData = await _location.getLocation();
      // setState(() {
      //   context.read<LoaderBloc>().state.currentPosition =
      //       LatLng(locationData.latitude!, locationData.longitude!);
      // });

      logger(
          'Origin is ${context.read<LoaderBloc>().state.currentPosition!.latitude}, ${context.read<LoaderBloc>().state.currentPosition!.longitude}');
      await _getAddressFromLatLng();
      if (context.mounted) {
        context.read<LoaderBloc>().resetState();
        showTripBottomSheet(
          context,
          currentAddress ?? '',
          context.read<LoaderBloc>().state.currentPosition == null
              ? ''
              : '${context.read<LoaderBloc>().state.currentPosition!.latitude},${context.read<LoaderBloc>().state.currentPosition!.longitude}',
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
