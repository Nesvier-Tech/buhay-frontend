class RouteRequest {
  Map<String, List<double>> start;
  List<Map<String, List<double>>> otherPoints;

  RouteRequest({
    required Map<String, List<double>> startCoordinates,
    required List<Map<String, List<double>>> otherPointsCoordinates,
  })  : start = startCoordinates,
        otherPoints = otherPointsCoordinates;

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'other_points': otherPoints,
    };
  }
}

class ConvertCoordinates {
  List<Map<String, List<double>>> coordinates;

  ConvertCoordinates({
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
    };
  }
}

class AddRequest {
  int personID;
  List<Map<String, List<double>>> coordinates;

  AddRequest({
    required this.personID,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'person_id': personID,
      'coordinates': coordinates,
    };
  }
}

class SaveRoute {
  int requestId;
  RouteRequest points;

  SaveRoute({
    required this.requestId,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'points': points,
    };
  }
}
