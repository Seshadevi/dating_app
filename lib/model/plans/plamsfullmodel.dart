class PlansFullModel {
  List<Data>? data;

  PlansFullModel({this.data});

  factory PlansFullModel.initial() => PlansFullModel(data: []);

  PlansFullModel copyWith({List<Data>? data}) {
    return PlansFullModel(
      data: data ?? this.data,
    );
  }

  bool get isLoading => data == null || data!.isEmpty;

  PlansFullModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? id;
  int? typeId;
  String? title;
  String? price;
  int? durationDays;
  int? quantity;
  PlanType? planType;

  Data({
    this.id,
    this.typeId,
    this.title,
    this.price,
    this.durationDays,
    this.quantity,
    this.planType,
  });

  factory Data.initial() => Data();

  Data copyWith({
    int? id,
    int? typeId,
    String? title,
    String? price,
    int? durationDays,
    int? quantity,
    PlanType? planType,
  }) {
    return Data(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      title: title ?? this.title,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      quantity: quantity ?? this.quantity,
      planType: planType ?? this.planType,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['typeId'];
    title = json['title'];
    price = json['price'];
    durationDays = json['durationDays'];
    quantity = json['quantity'];
    planType = json['planType'] != null
        ? PlanType.fromJson(json['planType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['typeId'] = typeId;
    map['title'] = title;
    map['price'] = price;
    map['durationDays'] = durationDays;
    map['quantity'] = quantity;
    if (planType != null) {
      map['planType'] = planType!.toJson();
    }
    return map;
  }
}

class PlanType {
  int? id;
  String? planName;
  String? description;
  List<Features>? features;

  PlanType({this.id, this.planName, this.description, this.features});

  factory PlanType.initial() => PlanType(features: []);

  PlanType copyWith({
    int? id,
    String? planName,
    String? description,
    List<Features>? features,
  }) {
    return PlanType(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      description: description ?? this.description,
      features: features ?? this.features,
    );
  }

  PlanType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['planName'];
    description = json['description'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['planName'] = planName;
    map['description'] = description;
    if (features != null) {
      map['features'] = features!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Features {
  int? id;
  String? featureName;

  Features({this.id, this.featureName});

  factory Features.initial() => Features();

  Features copyWith({
    int? id,
    String? featureName,
  }) {
    return Features(
      id: id ?? this.id,
      featureName: featureName ?? this.featureName,
    );
  }

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    featureName = json['featureName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['featureName'] = featureName;
    return map;
  }
}
