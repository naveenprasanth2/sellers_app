import '../global/global.dart';


class CartMethods {

  List<String>? separateItemIdsFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<String>? itemsIdsList = userCartList
        ?.where((element) => element.contains(":"))
        .map((e) => e.split(":")[0])
        .toList();
    return itemsIdsList;
  }

  List<int>? separateItemQuantitiesFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<int>? quantityList = userCartList
        ?.where(
          (element) => element.contains(":"),
        )
        .map((e) => int.parse(e.split(":")[1]))
        .toList();
    return quantityList;
  }

  List<String>? separateOrderItemIds(productIds) {
    List<String>? userCartList = List<String>.from(productIds);
    List<String>? itemsIdsList = userCartList
        .where((element) => element.contains(":"))
        .map((e) => e.split(":")[0])
        .toList();
    return itemsIdsList;
  }

  List<String>? separateItemQuantities(productIds) {
    List<String>? userCartList = List<String>.from(productIds);

    List<String>? quantityList = userCartList
        .where(
          (element) => element.contains(":"),
        ).map((e) => e.split(":")[1])
        .toList();

    return quantityList;
  }
}
