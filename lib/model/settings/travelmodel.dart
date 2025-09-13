class TravelModel {
  int? id;
  int? userId;
  int? travelMode;
  String? location;
  String? createdAt;
  String? updatedAt;

  TravelModel({
    this.id,
    this.userId,
    this.travelMode,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for an initial empty object
  factory TravelModel.initial() {
    return TravelModel(
      id: null,
      userId: null,
      travelMode: null,
      location: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// Creates a copy of the current object with optional new values
  TravelModel copyWith({
    int? id,
    int? userId,
    int? travelMode,
    String? location,
    String? createdAt,
    String? updatedAt,
  }) {
    return TravelModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      travelMode: travelMode ?? this.travelMode,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  TravelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    travelMode = json['travelMode'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['travelMode'] = travelMode;
    data['location'] = location;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
