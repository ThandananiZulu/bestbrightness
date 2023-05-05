class Model {
  
  final String stockName;
  final String stockAmount;

  Model({
  
    required this.stockName,
    required this.stockAmount,
  });

 
  Map<String, dynamic> toJson( json) {
    return {
      stockName: json['stockName'] ?? '',
      stockAmount: json['stockAmount'] ?? '',
    };
  }
}
