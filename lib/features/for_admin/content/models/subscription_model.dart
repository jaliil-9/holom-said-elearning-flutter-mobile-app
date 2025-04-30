class SubscriptionModel {
  final String id;
  final int promo;
  final int code;

  SubscriptionModel({
    required this.id,
    required this.promo,
    required this.code,
  });
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      promo: json['promo'] as int,
      code: json['code'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promo': promo,
      'code': code,
    };
  }
}
