import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? sourceLocation;
  // LatLng(-17.76590859412687, -63.10805075103434);
  // -17.76590859412687, -63.10805075103434
  LatLng? destination;
  // LatLng(-17.767880, -63.115658);
  // -17.767880, -63.115658
  List<LatLng> polyLineCoordinates = []; // Lineas de coordenadas
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });

    // GoogleMapController googleMapController = await _controller.future;

    // location.onLocationChanged.listen(
    //   (newLoc) {
    //     currentLocation = newLoc;
    //     googleMapController.animateCamera(CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //             zoom: 15.5,
    //             target: LatLng(newLoc.latitude!, newLoc.longitude!))));
    //     setState(() {});
    //   },
    // );

    setState(() {});
  }

  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
      PointLatLng(destination!.latitude, destination!.longitude),
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then((icon) {
      sourceIcon = icon;
    });
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

  @override
  void initState() {
    setCustomMarker();
    getCurrentLocation();
    if (sourceLocation != null && destination != null) {
      getPolyPoint();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Track order",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: currentLocation != null
                  ? LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!)
                  : const LatLng(-17.76590859412687, -63.10805075103434),
              zoom: 13.5),
          polylines: {
            Polyline(
                polylineId: const PolylineId("route"),
                points: polyLineCoordinates,
                color: primaryColor,
                width: 5)
          },
          markers: {
            if (currentLocation != null)
              Marker(
                markerId: const MarkerId("currentLocation"),
                position: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                icon: currentLocationIcon,
              ),
            if (sourceLocation != null)
              Marker(
                markerId: const MarkerId("source"),
                position: sourceLocation!,
                icon: sourceIcon,
              ),
            if (destination != null)
              Marker(
                markerId: const MarkerId("destination"),
                position: destination!,
                icon: destinationIcon,
              ),
          },
          myLocationButtonEnabled: false,
          compassEnabled: false,
          zoomGesturesEnabled: false,
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
          onTap: (LatLng latLng) {
            setState(() {
              if (sourceLocation == null) {
                sourceLocation = latLng;
              } else if (destination == null) {
                destination = latLng;
                getPolyPoint();
              } else {
                polyLineCoordinates = [];
                sourceLocation = latLng;
                destination = null;
              }
            });
          },
        ));
  }

  // Future<void> fetchRoutePoints() async {
  //   // Hacer una solicitud a la API Directions para obtener la ruta y los puntos
  //   final response = await http.get(Uri.parse(
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=Inicio&destination=Destino&key=TU_CLAVE_DE_API'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final routes = data['routes'];

  //     if (routes.isNotEmpty) {
  //       final points = routes[0]['overview_polyline']['points'];
  //       polyLineCoordinates = decodePolyline(points);

  //       setState(() {
  //         polylines.add(Polyline(
  //           polylineId: PolylineId('route'),
  //           color: Colors.blue,
  //           width: 5,
  //           points: routePoints,
  //         ));
  //       });

  //       mapController.animateCamera(
  //         CameraUpdate.newLatLngBounds(
  //           LatLngBounds(
  //             southwest: routePoints.first,
  //             northeast: routePoints.last,
  //           ),
  //           100.0, // Padding
  //         ),
  //       );
  //     }
  //   } else {
  //     throw Exception('Failed to fetch route points');
  //   }
  // }

  // List<LatLng> decodePolyline(String encoded) {
  //   List<LatLng> points = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int b, shift = 0, result = 0;

  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);

  //     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;

  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);

  //     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lng += dlng;

  //     LatLng point = LatLng((lat / 1e5), (lng / 1e5));
  //     points.add(point);
  //   }

  //   return points;
  // }
}
