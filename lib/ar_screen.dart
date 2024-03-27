// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController? arCoreController;
  ArCoreAugmentedImage? arCoreAugmentedImage;
  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARCore Marker Placement'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onARCoreViewCreated,
        enableUpdateListener: true,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onARCoreViewCreated(ArCoreController controller) {
    controller.onTrackingImage = (img) {};

    arCoreController = controller;
    arCoreController!.onNodeTap = (name) => print("Tapped on $name");
    arCoreController!.onPlaneTap = _onPlaneTap;

    // _addCube(arCoreController!);
  }

  void _onPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addMarker(arCoreController!, hit);
  }

  void _addMarker(ArCoreController controller, ArCoreHitTestResult hit) {
    final markerNode = ArCoreNode(
      shape: ArCoreCube(
        size: vector.Vector3(0.5, 0.5, 0.1),
        materials: [
          ArCoreMaterial(
            color: Colors.orangeAccent,
            metallic: 1.0,
          )
        ],
      ),
      position: hit.pose.translation,
    );

    setState(() {
      controller.addArCoreNode(markerNode);
    });
  }

  void _addCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }
}
