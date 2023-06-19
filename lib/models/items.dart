import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? itemId;
  String? brandId;
  String? sellerUid;
  String? sellerName;
  String? itemInfo;
  String? itemTitle;
  String? longDescription;
  String? price;
  Timestamp? publishDate;
  String? status;
  String? thumbnailUrl;

  Items(
      {this.itemId,
      this.brandId,
      this.sellerUid,
      this.sellerName,
      this.itemInfo,
      this.itemTitle,
      this.longDescription,
      this.price,
      this.publishDate,
      this.status,
      this.thumbnailUrl});

  Items.fromJson(Map<String, dynamic> json) {
    itemId = json["itemId"];
    brandId = json["brandId"];
    sellerUid = json["sellerUid"];
    sellerName = json["sellerName"];
    itemInfo = json["itemInfo"];
    itemTitle = json["itemTitle"];
    longDescription = json["longDescription"];
    price = json["price"];
    publishDate = json["publishDate"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}
