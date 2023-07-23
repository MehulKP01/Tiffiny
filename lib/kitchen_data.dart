class KitchenDataModel {
  final String? foodname;
  final List<String> curr;
  final int price;
  KitchenDataModel(
      {required this.foodname, required this.curr, required this.price});

  KitchenDataModel.fromMap(Map<dynamic, dynamic> res)
      : foodname = res['foodname'],
        curr = res['curr'],
        price = res['price'];

  Map<String, dynamic> toMap() {
    return {'foodname': foodname, 'curr': curr, 'price': price};
  }
}
