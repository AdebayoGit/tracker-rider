class Vehicle {
  String model;
  int year;
  String numberPlates;
  String vehicleId;
  String registrationDate;

  Vehicle({
    required this.model,
    required this.year,
    required this.vehicleId,
    required this.numberPlates,
    required this.registrationDate,
  });

  @override
  String toString() {
    return 'This vehicle is $model from $year, the Plate Number is $numberPlates and the Id is $vehicleId, registered $registrationDate';
  }
}
