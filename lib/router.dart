import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mao/UI/pages/login/login_page.dart';
import 'package:google_mao/UI/pages/mapa/mark_route_page.dart';
import 'package:google_mao/UI/providers/current_position.dart';
import 'package:google_mao/domain/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Router {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'mark_route',
            builder: (BuildContext context, GoRouterState state) {
              final Response response =
                  CurrentPosition.getCurrentPosition() as Response;
              if (response.error != null) {
                return MarkRoutePage(currentLocation: response.data as LatLng);
              } else {
                return const LoginPage();
              }
            },
          ),
        ],
      ),
    ],
  );
}
