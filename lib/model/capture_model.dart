class CaptureModel {
  final String imgTimestamp;
  final String stockName;
  final String scanCode;
  final String stockAmount;
  final String stockPrice;
  final String storageDate;
  final String storageTime;
  final String deliveredBy;
  CaptureModel(
      {required this.imgTimestamp,
      required this.stockName,
      required this.scanCode,
      required this.stockAmount,
      required this.stockPrice,
      required this.storageDate,
      required this.storageTime,
      required this.deliveredBy,
});
}
