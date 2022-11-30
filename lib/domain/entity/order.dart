class OrderEntity {
  late int id;
  final String date;
  final int idStatus;
  final int idUser;

  OrderEntity(
      {this.id = 0,
      required this.date,
      required this.idStatus,
      required this.idUser});
}
