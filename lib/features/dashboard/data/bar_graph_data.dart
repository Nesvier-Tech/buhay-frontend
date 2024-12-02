import 'package:flutter/material.dart';

import '../domain/entities/bar_graph_model.dart';
import '../domain/entities/graph_model.dart';

class BarGraphData {
  final data = [
    const BarGraphModel(
      label: "Flood Level",
      color: Color(0xFFFEB95A),
      graph: [
        GraphModel(x: 0, y: 8),
        GraphModel(x: 1, y: 10),
        GraphModel(x: 2, y: 7),
        GraphModel(x: 3, y: 4),
        GraphModel(x: 4, y: 4),
        GraphModel(x: 5, y: 6),
      ],
    ),
    const BarGraphModel(
      label: "Rain Level",
      color: Color(0xFFF2C8ED),
      graph: [
        GraphModel(x: 0, y: 8),
        GraphModel(x: 1, y: 10),
        GraphModel(x: 2, y: 9),
        GraphModel(x: 3, y: 6),
        GraphModel(x: 4, y: 6),
        GraphModel(x: 5, y: 7),
      ],
    ),
    const BarGraphModel(
      label: "Risk Level",
      color: Color(0xFF20AEF3),
      graph: [
        GraphModel(x: 0, y: 7),
        GraphModel(x: 1, y: 10),
        GraphModel(x: 2, y: 7),
        GraphModel(x: 3, y: 4),
        GraphModel(x: 4, y: 4),
        GraphModel(x: 5, y: 10),
      ],
    ),
  ];

  final label = ['I', 'II', 'III', 'IV', 'V', 'VI'];
}
