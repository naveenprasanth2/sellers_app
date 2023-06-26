class Address {
  String? name;
  String? phoneNumber;
  String? flatHouseNumber;
  String? streetName;
  String? city;
  String? stateCountry;
  String? completeAddress;

  Address(
    this.name,
    this.phoneNumber,
    this.flatHouseNumber,
    this.streetName,
    this.city,
    this.stateCountry,
    this.completeAddress,
  );

  Address.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    flatHouseNumber = json["flatHouseNumber"];
    streetName = json["streetName"];
    city = json["city"];
    stateCountry = json["stateCountry"];
    completeAddress = json["completeAddress"];
  }
}
