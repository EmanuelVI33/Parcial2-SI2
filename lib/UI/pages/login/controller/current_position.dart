import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mao/UI/components/dialog_error.dart';
import 'package:google_mao/UI/pages/mapa/mark_route_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentPosition {
  static Future<LatLng?> getCurrentPosition() async {
    Position? currentPosition;
    LatLng? position;

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      position = LatLng(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }

    return position;
  }

  static void goToMap(BuildContext context) async {
    final LatLng? currentPosition = await CurrentPosition.getCurrentPosition();

    if (currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkRoutePage(
            currentLocation: currentPosition,
          ),
        ),
      );
    } else {
      showDialog(context: context, builder: (context) => DialogError());
    }
  }
}
