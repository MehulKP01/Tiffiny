import 'package:get/get.dart';

class CartController extends GetxController {
  var total = 0.obs;
  var ItemLength = new Map().obs;
  List currItems = [].obs;
  List kitchen = [];
  void increment(int ind, int price, String name) {
    total.value += price;

    currItems.add(name);

    if (ItemLength.containsKey(name)) {
      ItemLength[name] += 1;
    } else {
      ItemLength[name] = 1;
    }
    print(ItemLength);
  }

  void decrement(int ind, int price, String name) {
    total.value -= price;
    ItemLength[name]--;
    currItems.removeLast();
  }
}
