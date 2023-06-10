import 'package:flutter/material.dart';
import 'package:google_mao/UI/pages/mapa/controller/mark_route_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MarkRoutePage extends StatelessWidget {
  const MarkRoutePage({super.key, required this.currentLocation});

  final LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          locationProvider.setCustomMarker();
          locationProvider.setCurrentLocation(currentLocation);

          return GoogleMap(
            onMapCreated: (controller) {
              locationProvider.mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocation.latitude,
                currentLocation.longitude,
              ),
              zoom: 14.0,
            ),
            markers: locationProvider.markerMap(),
            polylines: {
              Polyline(
                  polylineId: const PolylineId("route"),
                  points: locationProvider.polyLineCoordinates,
                  color: Colors.indigo,
                  width: 5)
            },
            onTap: locationProvider.onTap,
          );
          // }
        },
      ),
    );
  }

  Widget _buildDefaultMap() {
    return const GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
        zoom: 14.0,
      ),
    );
  }
}
