class PeoplesAllModel {
  List<Users>? users;

  PeoplesAllModel({this.users});

  factory PeoplesAllModel.fromJson(Map<String, dynamic> json) {
    return PeoplesAllModel(
      users: json['users'] != null
          ? List<Users>.from(json['users'].map((v) => Users.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users?.map((v) => v.toJson()).toList(),
    };
  }

  PeoplesAllModel copyWith({List<Users>? users}) {
    return PeoplesAllModel(users: users ?? this.users);
  }

  static PeoplesAllModel initial() => PeoplesAllModel(users: []);
}

class Users {
  int? id;
  String? mobile;
  String? mode;
  dynamic googleId;
  dynamic facebookId;
  String? firstName;
  String? lastName;
  dynamic age;
  String? dob;
  String? gender;
  String? status;
  String? bio;
  String? occupation;
  String? company;
  String? education;
  dynamic height;
  dynamic smoking;
  dynamic zodiac;
  dynamic religion;
  dynamic politicalViews;
  dynamic exercise;
  dynamic pets;
  dynamic languages;
  String? instagram;
  String? spotifyArtists;
  dynamic lastActive;
  int? profileCompletion;
  dynamic photoUrl;
  bool? isPrimaryPhoto;
  dynamic minAgePreference;
  dynamic maxAgePreference;
  dynamic maxDistancePreference;
  dynamic genderPreference;
  bool? twoFactorEnabled;
  bool? isProfileComplete;
  bool? privateMode;
  bool? showOnProfile;
  double? latitude;
  double? longitude;
  String? createdAt;
  String? updatedAt;
  List<Kids>? kids;
  List<Religions>? religions;
  List<Drinking>? drinking;
  List<Qualities>? qualities;
  List<CausesAndCommunities>? causesAndCommunities;
  List<DefaultMessages>? defaultMessages;
  List<ProfilePics>? profilePics;
  bool isLoading; // NEW

  Users({
    this.id,
    this.mobile,
    this.mode,
    this.googleId,
    this.facebookId,
    this.firstName,
    this.lastName,
    this.age,
    this.dob,
    this.gender,
    this.status,
    this.bio,
    this.occupation,
    this.company,
    this.education,
    this.height,
    this.smoking,
    this.zodiac,
    this.religion,
    this.politicalViews,
    this.exercise,
    this.pets,
    this.languages,
    this.instagram,
    this.spotifyArtists,
    this.lastActive,
    this.profileCompletion,
    this.photoUrl,
    this.isPrimaryPhoto,
    this.minAgePreference,
    this.maxAgePreference,
    this.maxDistancePreference,
    this.genderPreference,
    this.twoFactorEnabled,
    this.isProfileComplete,
    this.privateMode,
    this.showOnProfile,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.kids,
    this.religions,
    this.drinking,
    this.qualities,
    this.causesAndCommunities,
    this.defaultMessages,
    this.profilePics,
    this.isLoading = false,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      mobile: json['mobile'],
      mode: json['mode'],
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      dob: json['dob'],
      gender: json['gender'],
      status: json['status'],
      bio: json['bio'],
      occupation: json['occupation'],
      company: json['company'],
      education: json['education'],
      height: json['height'],
      smoking: json['smoking'],
      zodiac: json['zodiac'],
      religion: json['religion'],
      politicalViews: json['politicalViews'],
      exercise: json['exercise'],
      pets: json['pets'],
      languages: json['languages'],
      instagram: json['instagram'],
      spotifyArtists: json['spotifyArtists'],
      lastActive: json['lastActive'],
      profileCompletion: json['profileCompletion'],
      photoUrl: json['photoUrl'],
      isPrimaryPhoto: json['isPrimaryPhoto'],
      minAgePreference: json['minAgePreference'],
      maxAgePreference: json['maxAgePreference'],
      maxDistancePreference: json['maxDistancePreference'],
      genderPreference: json['genderPreference'],
      twoFactorEnabled: json['twoFactorEnabled'],
      isProfileComplete: json['isProfileComplete'],
      privateMode: json['privateMode'],
      showOnProfile: json['showOnProfile'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      kids: (json['kids'] as List?)?.map((v) => Kids.fromJson(v)).toList(),
      religions: (json['religions'] as List?)?.map((v) => Religions.fromJson(v)).toList(),
      drinking: (json['drinking'] as List?)?.map((v) => Drinking.fromJson(v)).toList(),
      qualities: (json['qualities'] as List?)?.map((v) => Qualities.fromJson(v)).toList(),
      causesAndCommunities: (json['causesAndCommunities'] as List?)?.map((v) => CausesAndCommunities.fromJson(v)).toList(),
      defaultMessages: (json['default_messages'] as List?)?.map((v) => DefaultMessages.fromJson(v)).toList(),
      profilePics: (json['profile_pics'] as List?)?.map((v) => ProfilePics.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'mode': mode,
      'googleId': googleId,
      'facebookId': facebookId,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'dob': dob,
      'gender': gender,
      'status': status,
      'bio': bio,
      'occupation': occupation,
      'company': company,
      'education': education,
      'height': height,
      'smoking': smoking,
      'zodiac': zodiac,
      'religion': religion,
      'politicalViews': politicalViews,
      'exercise': exercise,
      'pets': pets,
      'languages': languages,
      'instagram': instagram,
      'spotifyArtists': spotifyArtists,
      'lastActive': lastActive,
      'profileCompletion': profileCompletion,
      'photoUrl': photoUrl,
      'isPrimaryPhoto': isPrimaryPhoto,
      'minAgePreference': minAgePreference,
      'maxAgePreference': maxAgePreference,
      'maxDistancePreference': maxDistancePreference,
      'genderPreference': genderPreference,
      'twoFactorEnabled': twoFactorEnabled,
      'isProfileComplete': isProfileComplete,
      'privateMode': privateMode,
      'showOnProfile': showOnProfile,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'kids': kids?.map((v) => v.toJson()).toList(),
      'religions': religions?.map((v) => v.toJson()).toList(),
      'drinking': drinking?.map((v) => v.toJson()).toList(),
      'qualities': qualities?.map((v) => v.toJson()).toList(),
      'causesAndCommunities': causesAndCommunities?.map((v) => v.toJson()).toList(),
      'default_messages': defaultMessages?.map((v) => v.toJson()).toList(),
      'profile_pics': profilePics?.map((v) => v.toJson()).toList(),
    };
  }

  Users copyWith({
    int? id,
    String? mobile,
    String? mode,
    dynamic googleId,
    dynamic facebookId,
    String? firstName,
    String? lastName,
    dynamic age,
    String? dob,
    String? gender,
    String? status,
    String? bio,
    String? occupation,
    String? company,
    String? education,
    dynamic height,
    dynamic smoking,
    dynamic zodiac,
    dynamic religion,
    dynamic politicalViews,
    dynamic exercise,
    dynamic pets,
    dynamic languages,
    String? instagram,
    String? spotifyArtists,
    dynamic lastActive,
    int? profileCompletion,
    dynamic photoUrl,
    bool? isPrimaryPhoto,
    dynamic minAgePreference,
    dynamic maxAgePreference,
    dynamic maxDistancePreference,
    dynamic genderPreference,
    bool? twoFactorEnabled,
    bool? isProfileComplete,
    bool? privateMode,
    bool? showOnProfile,
    double? latitude,
    double? longitude,
    String? createdAt,
    String? updatedAt,
    List<Kids>? kids,
    List<Religions>? religions,
    List<Drinking>? drinking,
    List<Qualities>? qualities,
    List<CausesAndCommunities>? causesAndCommunities,
    List<DefaultMessages>? defaultMessages,
    List<ProfilePics>? profilePics,
    bool? isLoading,
  }) {
    return Users(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      mode: mode ?? this.mode,
      googleId: googleId ?? this.googleId,
      facebookId: facebookId ?? this.facebookId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      bio: bio ?? this.bio,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      education: education ?? this.education,
      height: height ?? this.height,
      smoking: smoking ?? this.smoking,
      zodiac: zodiac ?? this.zodiac,
      religion: religion ?? this.religion,
      politicalViews: politicalViews ?? this.politicalViews,
      exercise: exercise ?? this.exercise,
      pets: pets ?? this.pets,
      languages: languages ?? this.languages,
      instagram: instagram ?? this.instagram,
      spotifyArtists: spotifyArtists ?? this.spotifyArtists,
      lastActive: lastActive ?? this.lastActive,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      photoUrl: photoUrl ?? this.photoUrl,
      isPrimaryPhoto: isPrimaryPhoto ?? this.isPrimaryPhoto,
      minAgePreference: minAgePreference ?? this.minAgePreference,
      maxAgePreference: maxAgePreference ?? this.maxAgePreference,
      maxDistancePreference: maxDistancePreference ?? this.maxDistancePreference,
      genderPreference: genderPreference ?? this.genderPreference,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      privateMode: privateMode ?? this.privateMode,
      showOnProfile: showOnProfile ?? this.showOnProfile,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kids: kids ?? this.kids,
      religions: religions ?? this.religions,
      drinking: drinking ?? this.drinking,
      qualities: qualities ?? this.qualities,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      defaultMessages: defaultMessages ?? this.defaultMessages,
      profilePics: profilePics ?? this.profilePics,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  static Users initial() => Users();
}
class Kids {
  int? id;
  String? kids;

  Kids({this.id, this.kids});

  factory Kids.fromJson(Map<String, dynamic> json) {
    return Kids(
      id: json['id'],
      kids: json['kids'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kids': kids,
      };

  Kids copyWith({int? id, String? kids}) {
    return Kids(
      id: id ?? this.id,
      kids: kids ?? this.kids,
    );
  }

  static Kids initial() => Kids(id: 0, kids: '');
}

class Religions {
  int? id;
  String? religion;

  Religions({this.id, this.religion});

  factory Religions.fromJson(Map<String, dynamic> json) {
    return Religions(
      id: json['id'],
      religion: json['religion'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'religion': religion,
      };

  Religions copyWith({int? id, String? religion}) {
    return Religions(
      id: id ?? this.id,
      religion: religion ?? this.religion,
    );
  }

  static Religions initial() => Religions(id: 0, religion: '');
}

class Drinking {
  int? id;
  String? preference;

  Drinking({this.id, this.preference});

  factory Drinking.fromJson(Map<String, dynamic> json) {
    return Drinking(
      id: json['id'],
      preference: json['preference'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'preference': preference,
      };

  Drinking copyWith({int? id, String? preference}) {
    return Drinking(
      id: id ?? this.id,
      preference: preference ?? this.preference,
    );
  }

  static Drinking initial() => Drinking(id: 0, preference: '');
}

class Qualities {
  int? id;
  String? name;

  Qualities({this.id, this.name});

  factory Qualities.fromJson(Map<String, dynamic> json) {
    return Qualities(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Qualities copyWith({int? id, String? name}) {
    return Qualities(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  static Qualities initial() => Qualities(id: 0, name: '');
}

class CausesAndCommunities {
  int? id;
  String? causesAndCommunities;

  CausesAndCommunities({this.id, this.causesAndCommunities});

  factory CausesAndCommunities.fromJson(Map<String, dynamic> json) {
    return CausesAndCommunities(
      id: json['id'],
      causesAndCommunities: json['causesAndCommunities'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'causesAndCommunities': causesAndCommunities,
      };

  CausesAndCommunities copyWith({int? id, String? causesAndCommunities}) {
    return CausesAndCommunities(
      id: id ?? this.id,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
    );
  }

  static CausesAndCommunities initial() =>
      CausesAndCommunities(id: 0, causesAndCommunities: '');
}

class DefaultMessages {
  int? id;
  String? message;

  DefaultMessages({this.id, this.message});

  factory DefaultMessages.fromJson(Map<String, dynamic> json) {
    return DefaultMessages(
      id: json['id'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
      };

  DefaultMessages copyWith({int? id, String? message}) {
    return DefaultMessages(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  static DefaultMessages initial() => DefaultMessages(id: 0, message: '');
}

class ProfilePics {
  int? id;
  String? url;
  bool? isPrimary;

  ProfilePics({this.id, this.url, this.isPrimary});

  factory ProfilePics.fromJson(Map<String, dynamic> json) {
    return ProfilePics(
      id: json['id'],
      url: json['url'],
      isPrimary: json['isPrimary'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'isPrimary': isPrimary,
      };

  ProfilePics copyWith({int? id, String? url, bool? isPrimary}) {
    return ProfilePics(
      id: id ?? this.id,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  static ProfilePics initial() => ProfilePics(id: 0, url: '', isPrimary: false);
}
