class PlansPurchase {
  String? message;
  Data? data;

  PlansPurchase({this.message, this.data});

  // Factory: from JSON
  PlansPurchase.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  /// Initial factory (empty object)
  factory PlansPurchase.initial() {
    return PlansPurchase(
      message: "",
      data: Data.initial(),
    );
  }

  /// CopyWith
  PlansPurchase copyWith({
    String? message,
    Data? data,
  }) {
    return PlansPurchase(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? id;
  int? userId;
  int? planId;
  String? purchaseDate;
  String? expiryDate;
  String? status;

  Data({
    this.id,
    this.userId,
    this.planId,
    this.purchaseDate,
    this.expiryDate,
    this.status,
  });

  // Factory: from JSON
  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    planId = json['planId'];
    purchaseDate = json['purchaseDate'];
    expiryDate = json['expiryDate'];
    status = json['status'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['planId'] = planId;
    data['purchaseDate'] = purchaseDate;
    data['expiryDate'] = expiryDate;
    data['status'] = status;
    return data;
  }

  /// Initial factory (empty object)
  factory Data.initial() {
    return Data(
      id: 0,
      userId: 0,
      planId: 0,
      purchaseDate: "",
      expiryDate: "",
      status: "",
    );
  }

  /// CopyWith
  Data copyWith({
    int? id,
    int? userId,
    int? planId,
    String? purchaseDate,
    String? expiryDate,
    String? status,
  }) {
    return Data(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
    );
  }
}
