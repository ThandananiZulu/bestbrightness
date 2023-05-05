class ViewitemsModel {
  final int id;
  final String imgTimestamp;
  final String stockName;
  final String scanCode;
  final int stockAmount;
  final int stockPrice;

  ViewitemsModel({
    required this.id,
    required this.imgTimestamp,
    required this.stockName,
    required this.scanCode,
    required this.stockAmount,
    required this.stockPrice,
  
  });

  factory ViewitemsModel.fromJson(dynamic json) {
    return ViewitemsModel(
      id: json['id'] ?? 0,
      imgTimestamp: json['imgTimestamp'] ?? '',
      stockName: json['stockName'] ?? '',
      scanCode: json['scanCode'] ?? '',
      stockAmount: json['stockAmount'] ?? 0,
      stockPrice: json['stockPrice'] ?? 0,
      
    );
  }
}
