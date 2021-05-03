import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Google maps location page

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _device =
        ModalRoute.of(context).settings.arguments;
    final LatLng _position = LatLng(_device['lat'], _device['lng']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('${_device['name']}\'s last known location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _position, zoom: 20.0),
            markers: {
              Marker(
                position: _position,
                markerId: MarkerId(_position.toString()),
                infoWindow: InfoWindow(
                  title: _device['name'],
                  snippet:
                      'lat: ${_position.latitude}, lng: ${_position.longitude}',
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: '${_position.latitude} ${_position.longitude}'));
                  },
                ),
              ),
            },
            mapType: MapType.hybrid,
          ),
        ],
      ),
    );
  }
}
