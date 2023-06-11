import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mao/UI/components/dialog_error.dart';
import 'package:google_mao/UI/pages/mapa/mark_route_page.dart';
import 'package:google_mao/domain/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentPosition {
  static Future<Response> getCurrentPosition() async {
    Position? currentPosition;
    final response = Response();

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      response.data =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      response.error = 'Error al obtener la ubicacion';
    }

    return Response();
  }

  static void goToMap(BuildContext context) async {
    final Response response = await CurrentPosition.getCurrentPosition();

    if (response.error != null) {
      final LatLng currentPosition = response.data as LatLng;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkRoutePage(
            currentLocation: currentPosition,
          ),
        ),
      );
    } else {
      showDialog(context: context, builder: (context) => const DialogError());
    }
  }
}
