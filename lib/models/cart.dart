class Cart {
  late int id;
  int productId;
  int quantity;

  Cart(this.productId, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity
    };
  }
}
