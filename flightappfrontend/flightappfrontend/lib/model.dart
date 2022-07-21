//@dart=2.9
class FlightModel {
  String id;
  String flightno;
  String departure_city;
  String arrival_city;
  String departure_time;
  String arrival_time;


  FlightModel({
    this.id,
    this.flightno,
    this.departure_city,
    this.arrival_city,
    this.departure_time,
    this.arrival_time,

  });
  factory FlightModel.fromJson(Map<dynamic,dynamic> json){
    return FlightModel(
      id: json['id'].toString(),
      flightno: json['flight_number'].toString(),
      departure_city: json['departure_city'].toString(),
      arrival_city: json['arrival_city'].toString(),
      departure_time: json['departure_time'].toString(),
      arrival_time: json['arrival_time'].toString(),

    );

  }


}