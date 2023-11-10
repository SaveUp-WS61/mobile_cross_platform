class User {
  late int id;
  int tableId;
  String type;

  User(this.tableId, this.type);

  Map<String, dynamic> toMap() {
    return {
      'tableId': tableId,
      'type': type
    };
  }
}