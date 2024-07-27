import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import '../widgets/ar_overlay.dart';
import '../services/ar_service.dart';
import '../services/storage_service.dart';

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARService arService = ARService();
  StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARView(
            onARViewCreated: arService.onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          AROverlay(
            onPlaceDot: _placeDot,
            detectedPlanes: arService.detectedPlanes,
          ),
        ],
      ),
    );
  }

  void _placeDot() async {
    final dot = await arService.placeDot();
    if (dot != null) {
      await storageService.saveDot(dot);
      // Update UI or show confirmation
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedDots();
  }

  void _loadSavedDots() async {
    final dots = await storageService.getSavedDots();
    arService.renderSavedDots(dots);
  }
}
