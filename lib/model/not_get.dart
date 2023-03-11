import '../extensions/extensions.dart';

class NotGet {
  NotGet({
    required this.stationName,
    required this.lat,
    required this.lng,
    required this.address,
    required this.inOut,
  });

  factory NotGet.fromJson(Map<String, dynamic> json) => NotGet(
        stationName: json['station_name'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        address: json['address'].toString(),
        inOut: json['in_out'].toString().toInt(),
      );

  String stationName;
  String lat;
  String lng;
  String address;
  int inOut;

  Map<String, dynamic> toJson() => {
        'station_name': stationName,
        'lat': lat,
        'lng': lng,
        'address': address,
      };
}
