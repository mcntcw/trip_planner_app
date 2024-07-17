import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_repository/trip_repository_library.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class TripMapScreen extends StatefulWidget {
  final Trip trip;
  const TripMapScreen({super.key, required this.trip});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Set<Marker> markers = {};
  initMarkers() async {
    markers = {};
    for (int i = 0; i < widget.trip.stops.length; i++) {
      final stop = widget.trip.stops[i];

      final markerIcon = await MarkerContainer(
        place: stop,
        index: i + 1,
      ).toBitmapDescriptor(
        logicalSize: const Size(200, 200),
        imageSize: const Size(600, 400),
      );

      markers.add(
        Marker(
          markerId: MarkerId('${stop.latitude},${stop.longitude}'),
          position: LatLng(stop.latitude, stop.longitude),
          icon: markerIcon,
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    initMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> routePoints = widget.trip.stops.map((stop) => LatLng(stop.latitude, stop.longitude)).toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.trip.stops[0].latitude, widget.trip.stops[0].longitude),
              zoom: 4,
            ),
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: routePoints,
                color: Colors.blue,
                width: 5,
              ),
            },
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.back,
                      size: 20,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarkerContainer extends StatelessWidget {
  final Place place;
  final int index;
  const MarkerContainer({
    super.key,
    required this.place,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MessageClipper(),
      child: Container(
        padding: const EdgeInsets.all(26),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 29, 29, 29).withOpacity(0.8),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              index.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16,
              ),
            ),
            place.arrival != null && place.departure != null
                ? Text(
                    '${DateFormat('dd.MM.yyyy').format(place.arrival!)} - ${DateFormat('dd.MM.yyyy').format(place.departure!)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 10,
                    ),
                  )
                : Container(),
            Text(
              place.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
