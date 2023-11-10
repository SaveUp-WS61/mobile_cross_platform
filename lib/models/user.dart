class User {
  int id;
  int tableId;
  String type;

  User(this.id, this.tableId, this.type);

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0)? null : id,
      'tableId': tableId,
      'type': type
    };
  }
}