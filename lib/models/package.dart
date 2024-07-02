class Package {
  final String id;
  final String name;
  final String description;
  final String location;
  final String image;

  const Package(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      required this.image});

  /// Constructor nombrado que crea una instancia de Package a partir de un JSON
  Package.fromJson(Map<String, dynamic> json)
      : id = json["idProducto"],
        name = json["nombre"],
        description = json["descripcion"],
        location = json["ubicacin"],
        image = json["imagen"];

  /// Método que convierte una instancia de Package a un JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  /// Constructor nombrado que crea una instancia de Package a partir de un Map
  Package.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        image = map['image'],
        location = '';
}
