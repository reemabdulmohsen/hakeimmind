import 'package:graphview/graphview.dart';
import 'package:flutter/material.dart';

class NodeWidget extends StatelessWidget {
  final Node node;

  NodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    // TODO: Customize the appearance of the node widget based on the provided 'node' object
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.black, // Set the border color to black
          width: 2.0, // Set the border width
        ),
      ),
      child: Text(
        node.key.toString().trim(),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
