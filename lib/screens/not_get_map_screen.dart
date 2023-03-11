// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../viewmodel/station_stamp_notifier.dart';

class NotGetMapScreen extends ConsumerWidget {
  NotGetMapScreen({super.key});

  late CameraPosition initialCameraPosition;

  late GoogleMapController googleMapController;

  final Set<Marker> markers = {};

  late WidgetRef _ref;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    setMapParam();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => googleMapController = controller,
              markers: markers,
              initialCameraPosition: initialCameraPosition,
            ),
          ),
        ],
      ),
    );
  }

  ///
  void setMapParam() {
    //---------------------------------------------//
    const funabashi = '35.7102009,139.9490672';
    final exFunabashi = funabashi.split(',');
    final latLng =
        LatLng(double.parse(exFunabashi[0]), double.parse(exFunabashi[1]));

    initialCameraPosition = CameraPosition(target: latLng, zoom: 13, tilt: 50);
    //---------------------------------------------//

    final stationStampNotGetState = _ref.watch(stationStampNotGetProvider);

    var i = 0;
    stationStampNotGetState.forEach((element) {
      markers.add(
        Marker(
          markerId: MarkerId('marker$i'),
          position: LatLng(
            double.parse(element.lat),
            double.parse(
              element.lng,
            ),
          ),
          infoWindow: InfoWindow(
            title: element.stationName,
            snippet: element.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            (element.inOut == 1)
                ? BitmapDescriptor.hueBlue
                : BitmapDescriptor.hueRose,
          ),
        ),
      );

      i++;
    });
  }
}
