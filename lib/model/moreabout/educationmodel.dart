class Educationmodel {
  int? id;
  String? institution;
  dynamic gradYear; // Changed from Null? to dynamic? for flexibility
  String? createdAt;
  String? updatedAt;
  bool isLoading;

  Educationmodel({
    this.id,
    this.institution,
    this.gradYear,
    this.createdAt,
    this.updatedAt,
    this.isLoading = false,
  });

  factory Educationmodel.initial() {
    return Educationmodel(
      id: null,
      institution: '',
      gradYear: null,
      createdAt: '',
      updatedAt: '',
      isLoading: false,
    );
  }

  Educationmodel copyWith({
    int? id,
    String? institution,
    dynamic gradYear,
    String? createdAt,
    String? updatedAt,
    bool? isLoading,
  }) {
    return Educationmodel(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      gradYear: gradYear ?? this.gradYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Educationmodel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        institution = json['institution'],
        gradYear = json['gradYear'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        isLoading = json['isLoading'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution'] = institution;
    data['gradYear'] = gradYear;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isLoading'] = isLoading;
    return data;
  }
}
