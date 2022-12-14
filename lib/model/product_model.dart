class ProductModel {
  String? id;
  late String sellerId;
  late String imagePath;
  late num price;
  late String location;
  late String title;
  late String description;

  ProductModel();

  ProductModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    sellerId = map['sellerId'];
    imagePath = map['imagePath'];
    price = map['price'];
    location = map['location'];
    title = map['title'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['sellerId'] = sellerId;
    map['imagePath'] = imagePath;
    map['price'] = price;
    map['location'] = location;
    map['title'] = title;
    map['description'] = description;
    return map;
  }
}
