class Donor {
  final int id;
  final String bloodGrp,gender;
  final double latitude;
  final double longitude;
  final int credits;

  Donor._({this.id,this.bloodGrp,this.gender,this.latitude,this.longitude,this.credits});

  factory Donor.fromJson(Map<String, dynamic> json) {
    return new Donor._(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      credits: json['credits'],
      bloodGrp: json['blood_grp'],
      gender: json['gender']
    );
  }
}