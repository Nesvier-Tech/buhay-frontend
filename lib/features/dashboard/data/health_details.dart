import '../domain/entities/health_model.dart';

class HealthDetails {
  final healthData = const [
    HealthModel(
      icon: 'assets/icons/location.png',
      value: "305",
      title: "SOS Count",
    ),
    HealthModel(
      icon: 'assets/icons/helping-hand.png',
      value: "10,983",
      title: "Saved Lives",
    ),
    HealthModel(
      icon: 'assets/icons/distance.png',
      value: "7km",
      title: "Route Distance",
    ),
    HealthModel(
      icon: 'assets/icons/clock.png',
      value: "7h48m",
      title: "ETA",
    ),
  ];
}
