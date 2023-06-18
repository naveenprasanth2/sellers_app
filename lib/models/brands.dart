import 'package:cloud_firestore/cloud_firestore.dart';

class Brands {
  String? brandId;
  String? brandInfo;
  String? brandTitle;
  Timestamp? publishDate;
  String? sellerUid;
  String? status;
  String? thumbnailUrl;

  Brands(
      {this.brandId,
      this.brandInfo,
      this.brandTitle,
      this.publishDate,
      this.sellerUid,
      this.status,
      this.thumbnailUrl});

  Brands.fromJson(Map<String, dynamic> json) {
    brandId = json["brandId"];
    brandInfo = json["brandInfo"];
    brandTitle = json["brandInfo"];
    publishDate = json["publishDate"];
    sellerUid = json["sellerUid"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}
