import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphview/graphview.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'NodeWidget.dart';
import 'mind_map_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  int _nodeIdCounter = 0;

  int getNodeId() {
    return _nodeIdCounter++;
  }
  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();



  GraphView _buildMindMapWidget(dynamic mindMapData) {
    builder.orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
    builder
    ..siblingSeparation = (30)
    ..levelSeparation = (40)
    ..subtreeSeparation = (40);

    // Process the mind map data and create the graph view
    Map<String, dynamic> mapData = json.decode(mindMapData);

    // Create the root node
    final rootNode = Node.Id(mapData['Root']);
    graph.addNode(rootNode);

    // Create the child nodes and edges
    List<dynamic> children = mapData['Children'];
    _createNodesAndEdges(children, rootNode);

    return GraphView(
      graph: graph,
      algorithm: BuchheimWalkerAlgorithm(builder,TreeEdgeRenderer(builder)),
      paint: Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
      builder: (Node node) {
        // Create a fade-in animation for the node widget
        return Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.black, // Set the border color to black
              width: 2.0, // Set the border width
            ),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 15
            ),
            child: AnimatedTextKit(
              pause: const Duration(milliseconds: 200),
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(node.key.toString()),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        );
      }
    );
  }

  void _createNodesAndEdges(List<dynamic> children, Node parentNode) {
    for (var child in children) {
      final childNode = Node.Id(child['name']);
      graph.addNode(childNode);
      graph.addEdge(parentNode, childNode);

      if (child.containsKey('Children')) {
        List<dynamic> subChildren = child['Children'];
        _createNodesAndEdges(subChildren, childNode);
      }
    }
  }


  String diseaseName = '';

  void buildMindMap() async {
    try {
      final mindMapData = await MindMapService.fetchMindMapData(diseaseName);

      setState(() {
        mindMapWidget = _buildMindMapWidget(mindMapData);
      });
    } catch (e) {
      // Error handling
      print('Error building mind map: $e');
    }
  }

  GraphView? mindMapWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 500,
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Image.asset(
                  'lib/assets/logo.png', // Replace with the path to your logo image
                  fit: BoxFit.contain, // Adjust the image fit as needed
                ),
                SizedBox(height: 36.0),
                Container(
                  width: 300,
                  height: 40,
                  child: TextField(

                    onChanged: (value) {
                      setState(() {
                        diseaseName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Enter disease name',

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(color: Colors.black, width: 0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(

                    onPressed: buildMindMap,
                    style: ElevatedButton.styleFrom(

                      primary: Colors.black,
                      onPrimary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: Text('Build Mind Map'),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(

            child: Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: mindMapWidget ?? Container(),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
