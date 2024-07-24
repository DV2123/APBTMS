class Bus
{
  Bus({
    required this.busUID,
    required this.busNumberPlate,
    required this.currentNumberOfPassenger,
    required this.totalPassengerCapacity,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.driverName,
    required this.temporaryNotification,
    required this.busRouteStart,
    required this.busRouteEnd
  });

  String busUID;
  String busNumberPlate;
  String driverName;
  int totalPassengerCapacity;
  int currentNumberOfPassenger;
  double currentLatitude;
  double currentLongitude;
  String busRouteStart;
  String busRouteEnd;
  String temporaryNotification;
}
