import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:collection/collection.dart';
import '../models/dot.dart';
import '../models/grid.dart';

class ARService {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  List<ARPlaneAnchor> detectedPlanes = [];
  Grid grid = Grid();

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    arObjectManager.onNodeTap = onNodeTapped;
  }

  void onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) {
    final hit = hitTestResults.firstWhereOrNull(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

    if (hit != null) {
      _addPlane(hit);
    }
  }

  void _addPlane(ARHitTestResult hit) {
    final newPlane = ARPlaneAnchor(transformation: hit.worldTransform);
    detectedPlanes.add(newPlane);
    // Notify UI to update
  }

  void onNodeTapped(List<String> nodeNames) {
    // Handle node (dot) tapped event
  }

  Future<Dot?> placeDot() async {
    if (detectedPlanes.isEmpty) return null;

    final anchor = detectedPlanes.first;
    final worldPosition = anchor.transformation.getTranslation();
    final gridPosition =
        grid.worldToGridCoordinates([worldPosition.x, worldPosition.y]);

    // Here you would normally host the anchor in the cloud and get an ID
    // For this POC, we'll just use the local anchor ID
    final cloudAnchorId = anchor.hashCode.toString();

    final dot = Dot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gridPosition: gridPosition,
      cloudAnchorId: cloudAnchorId,
    );

    await _renderDot(dot);

    return dot;
  }

  Future<void> _renderDot(Dot dot) async {
    final worldPosition = grid.gridToWorldCoordinates(dot.gridPosition);
    final node = ARNode(
      type: NodeType.localGLTF2,
      uri: "models/sphere.gltf",
      scale: Vector3(0.1, 0.1, 0.1),
      position: Vector3(worldPosition[0], worldPosition[1], 0),
    );
    bool? didAddNodeSuccess = await arObjectManager.addNode(node);
    if (didAddNodeSuccess!) {
      // Node added successfully
    } else {
      // Failed to add node
    }
  }

  void renderSavedDots(List<Dot> dots) {
    for (var dot in dots) {
      _renderDot(dot);
    }
  }
}
