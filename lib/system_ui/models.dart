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

class TestData {}

// RouteRequest should accept the following
// RouteRequest({
// "start": [longitude, latitude],
// "other_points": [
//  {
//   "coordinates": [longitude, latitude]
// },
// ]
// })

