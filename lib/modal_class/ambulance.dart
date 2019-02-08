class Ambulance {
  final int id,number;
  final String name,gender;
  final double latitude,longitude;
  final bool online;

  Ambulance._({this.id,this.name,this.gender,this.latitude,this.longitude,this.number,this.online});

  factory Ambulance.fromJson(Map<String, dynamic> json) {
    return new Ambulance._(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      number: json['number'],
      name: json['name'],
      online: json['online']
    );
  }
}