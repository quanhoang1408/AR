import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ARKitController arkitController;
  ARKitReferenceNode? node;
  ARKitReferenceNode? node1;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('ARKit in Flutter'),
      ),
      body: Container(
        child: ARKitSceneView(
          showFeaturePoints: true,
          planeDetection: ARPlaneDetection.horizontal,
          onARKitViewCreated: onARKitViewCreated,
        ),
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    arkitController.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitPlaneAnchor) {
      _addPlane(arkitController, anchor);
    }
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    if (node != null && node1 != null) {
      controller.remove(node!.name);
      controller.remove(node1!.name);
    }
    node = ARKitReferenceNode(
      url: 'models.scnassets/spaceship.dae',
      scale: vector.Vector3.all(0.1),
    );
    node1 = ARKitReferenceNode(
      url: 'models.scnassets/dash.dae',
      scale: vector.Vector3.all(0.3),
      position: vector.Vector3(0, 0, -1.0)
    );
    controller.add(node!, parentNodeName: anchor.nodeName);
    controller.add(node1!, parentNodeName: anchor.nodeName);
  }
  // ARKitNode _placeObject() {
  //   final material =
  //   ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.yellow));
  //   sphere = ARKitSphere(
  //     materials: [material],
  //     radius: 0.1,
  //   );
  //
  //   return ARKitNode(
  //     name: 'sphere',
  //     geometry: sphere,
  //     position: vector.Vector3(0, 0, -0.5),
  //   );
  // }
  //
  // void onNodeTapHandler(List<String> nodesList) {
  //   final name = nodesList.first;
  //   final color =
  //   (sphere!.materials.value!.first.diffuse as ARKitMaterialColor).color ==
  //       Colors.yellow
  //       ? Colors.blue
  //       : Colors.yellow;
  //   sphere!.materials.value = [
  //     ARKitMaterial(diffuse: ARKitMaterialProperty.color(color))
  //   ];
  //   showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         AlertDialog(content: Text('You tapped on $name')),
  //   );
  // }

}
