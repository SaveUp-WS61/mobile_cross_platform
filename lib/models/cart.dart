class Cart {
  int id;
  int productId;
  int quantity;

  Cart(this.id, this.productId, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0)? null : id,
      'productId': productId,
      'quantity': quantity
    };
  }
}
