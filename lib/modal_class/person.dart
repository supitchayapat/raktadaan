class Photo {
  final String title;

  Photo._({this.title});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo._(
      title: json['username'],
    );
  }
}