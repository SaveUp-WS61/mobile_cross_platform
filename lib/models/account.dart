class Account {
  int id;
  int tableId;
  String email;
  String name;
  String address;
  String department;
  String district;
  String phoneNumber;
  String password;
  String repeatPassword;
  String lastName;
  String ruc;
  int points;
  String type;

  Account(
    this.id,
    this.tableId,
    this.email,
    this.name,
    this.address,
    this.department,
    this.district,
    this.phoneNumber,
    this.password,
    this.repeatPassword,
    this.lastName,
    this.ruc,
    this.points,
    this.type
  );

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0)? null : id,
      'tableId': tableId,
      'email': email,
      'name': name,
      'address': address,
      'department': department,
      'district': district,
      'phoneNumber': phoneNumber,
      'password': password,
      'repeatPassword': repeatPassword,
      'lastName': lastName,
      'ruc': ruc,
      'points': points,
      'type': type
    };
  }
}