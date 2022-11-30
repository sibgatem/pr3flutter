class BicycleEntity {
  late int id;
  final double price;
  final int idtype;
  final int idGender;
  final int idAge;

  BicycleEntity(
      {this.id = 0,
      required this.price,
      required this.idtype,
      required this.idGender,
      required this.idAge});
}
