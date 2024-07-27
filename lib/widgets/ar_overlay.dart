import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

class AROverlay extends StatelessWidget {
  final VoidCallback onPlaceDot;
  final List<ARPlaneAnchor> detectedPlanes;
  AROverlay({required this.onPlaceDot, required this.detectedPlanes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: ElevatedButton(
              onPressed: onPlaceDot,
              child: Text('Place Dot'),
            ),
          ),
        ),
        if (detectedPlanes.isNotEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 32.0),
              child:
                  Text('Wall Detected', style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}
