import 'package:equatable/equatable.dart';


class Restaurant extends Equatable {
  static const defaultPhoto = 'https://fscomps.fotosearch.com/compc/CSP/CSP756/comida-r%C3%A1pida-cuadrado-icono-conjunto-clipart__k42079342.jpg';
  final String name;
  final String distance;
  final String imageUrl;

  const Restaurant({
    this.name,
    this.distance,
    this.imageUrl,
  });

  @override
  List<Object> get props => [
    name,
    distance,
    imageUrl,
  ];

  static Restaurant fromJson(dynamic json) {

    final String photo = json.containsKey('photo') ? json['photo']['images']['small']['url'] : defaultPhoto;
    return Restaurant(
      name: json['name'],
      distance: json['distance_string'],
      imageUrl: photo,
    );
  }

}