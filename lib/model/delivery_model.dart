class DeliveryModel {
  final int id;
  final String imgName;
  final String deliveryDate;
  final String deliveryTime;
  final String items;
  final String deliveredBy;

  DeliveryModel({
    required this.id,
    required this.imgName,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveredBy,
    required this.items,
  });

  factory DeliveryModel.fromJson(dynamic json) {
    return DeliveryModel(
      id: json['id'] ?? 0,
      imgName: json['imgName'] ?? '',
      deliveryDate: json['deliveryDate'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      deliveredBy: json['deliveredBy'] ?? '',
      items: json['items'] ?? '',
    );
  }
}
