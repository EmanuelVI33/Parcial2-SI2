import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/UI/pages/login/controller/current_position.dart';
import 'package:google_mao/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> polyLineCoordinates = []; // Lineas de coordenadas
  GoogleMapController? _mapController;
  String? _error;

  // Iconos para los marcadores
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  // Inicializar los marcadores
   void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  // Todos los marcadores
  Set<Marker> markerMap() {
    return <Marker>{
      if (_currentLocation != null)
        Marker(
          markerId: const MarkerId("currentLocation"),
          position:
              LatLng(currentLocation!.latitude, currentLocation!.longitude),
          icon: currentLocationIcon,
        ),
      if (destination != null)
        Marker(
          markerId: const MarkerId("destination"),
          position: destination!,
          icon: destinationIcon,
        ),
    };
  }

  // Rutas
  Set<Polyline> polylineMap() => <Polyline>{
        Polyline(
            polylineId: const PolylineId("route"),
            points: polyLineCoordinates,
            color: Colors.indigo,
            width: 5)
      };

  LatLng? get currentLocation => _currentLocation;
  LatLng? get destination => _destination;
  GoogleMapController? get mapController => _mapController;
  String? get error => _error;

  void setCurrentLocation(LatLng latLng) {
    _currentLocation = latLng;
  }

  set mapController(GoogleMapController? controller) {
    _mapController = controller;
  }

  // Actualizar ubicacion
  Future<LatLng?> updateLocation() async {
    final currentLocation = await CurrentPosition.getCurrentPosition();
    if (currentLocation != null) {
      _currentLocation = currentLocation;
      notifyListeners();
    }
  }

  // Dibujar ruta
  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      PointLatLng(_destination!.latitude, _destination!.longitude),
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    notifyListeners();
  }

  // Cuando marke en el mapa
  void onTap(LatLng latLng) {
    if (destination == null) {
      _destination = latLng;
      getPolyPoint();
    } else {
      polyLineCoordinates = [];
      _currentLocation = latLng;
      _destination = null;
    }
    notifyListeners();
  }
}
