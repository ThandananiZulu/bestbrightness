class PickupModel {
  final int id;
  final String imgName;
  final String pickupDate;
  final String pickupTime;
  final String items;
  final String pickedupBy;

  PickupModel({
    required this.id,
    required this.imgName,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickedupBy,
    required this.items,
  });

  factory PickupModel.fromJson(dynamic json) {
    return PickupModel(
      id: json['id'] ?? 0,
      imgName: json['imgName'] ?? '',
      pickupDate: json['pickupDate'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      pickedupBy: json['pickedupBy'] ?? '',
      items: json['items'] ?? '',
    );
  }
}
