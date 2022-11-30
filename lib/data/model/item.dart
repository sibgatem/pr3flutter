import '../../domain/entity/item.dart';

class Item extends ItemEntity {
  Item(
      {super.id = 0,
      required super.idUser,
      required super.idBicycle,
      required super.count});

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'id_bicycle': idBicycle,
      'count': count,
    };
  }

  factory Item.toFromMap(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      idUser: json['id_user'] as int,
      idBicycle: json['id_bicycle'] as int,
      count: json['count'] as int,
    );
  }
}
