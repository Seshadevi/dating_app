class SocketUserResponse {
  List<int>? modeFilter;
  ModeFilterMeta? modeFilterMeta;
  Pagination? pagination;
  List<Data>? data;

  SocketUserResponse(
      {this.modeFilter, this.modeFilterMeta, this.pagination, this.data});

  SocketUserResponse.fromJson(Map<String, dynamic> json) {
    modeFilter = json['modeFilter'].cast<int>();
    modeFilterMeta = json['modeFilterMeta'] != null
        ? new ModeFilterMeta.fromJson(json['modeFilterMeta'])
        : null;
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modeFilter'] = this.modeFilter;
    if (this.modeFilterMeta != null) {
      data['modeFilterMeta'] = this.modeFilterMeta!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModeFilterMeta {
  String? s4;

  ModeFilterMeta({this.s4});

  ModeFilterMeta.fromJson(Map<String, dynamic> json) {
    s4 = json['4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['4'] = this.s4;
    return data;
  }
}

class Pagination {
  int? page;
  int? totalPages;

  Pagination({this.page, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Data {
  int? id;
  String? mobile;
  String? role;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? pronouns;
  String? dob;
  bool? showOnProfile;
  String? headLine;
  bool? termsAndConditions;
  bool? isVerified;
  List<Qualities>? qualities;
  List<Drinking>? drinking;
  List<Kids>? kids;
  List<Religions>? religions;
  List<Interests>? interests;
  List<LookingFor>? lookingFor;
  List<CausesAndCommunities>? causesAndCommunities;
  List<Prompts>? prompts;
  List<DefaultMessages>? defaultMessages;
  List<ProfilePics>? profilePics;
  Qualities? starSign;
  Education? education;
  List<Works>? works;
  Location? location;
  String? educationLevel;
  String? exercise;
  String? haveKids;
  List<GenderIdentities>? genderIdentities;
  String? smoking;
  String? politics;
  String? hometown;
  int? height;
  List<Language>? spokenLanguages;
  int? createdByAdminId;
  List<Mode>? modes;
  List<Relationships>? relationships;
  List<Industries>? industries;
  List<Experiences>? experiences;
  String? newToArea;
  SnoozStatus? snoozStatus;
  TravelMode? travelMode;
  List<PurchasedPlans>? purchasedPlans;
  int? profileCompletion;

  Data(
      {this.id,
        this.mobile,
        this.role,
        this.email,
        this.firstName,
        this.lastName,
        this.gender,
        this.pronouns,
        this.dob,
        this.showOnProfile,
        this.headLine,
        this.termsAndConditions,
        this.isVerified,
        this.qualities,
        this.drinking,
        this.kids,
        this.religions,
        this.interests,
        this.lookingFor,
        this.causesAndCommunities,
        this.prompts,
        this.defaultMessages,
        this.profilePics,
        this.starSign,
        this.education,
        this.works,
        this.location,
        this.educationLevel,
        this.exercise,
        this.haveKids,
        this.genderIdentities,
        this.smoking,
        this.politics,
        this.hometown,
        this.height,
        this.spokenLanguages,
        this.createdByAdminId,
        this.modes,
        this.relationships,
        this.industries,
        this.experiences,
        this.newToArea,
        this.snoozStatus,
        this.travelMode,
        this.purchasedPlans,
        this.profileCompletion});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    pronouns = json['pronouns'];
    dob = json['dob'];
    showOnProfile = json['showOnProfile'];
    headLine = json['headLine'];
    termsAndConditions = json['termsAndConditions'];
    isVerified = json['isVerified'];
    if (json['qualities'] != null) {
      qualities = <Qualities>[];
      json['qualities'].forEach((v) {
        qualities!.add(new Qualities.fromJson(v));
      });
    }
    if (json['drinking'] != null) {
      drinking = <Drinking>[];
      json['drinking'].forEach((v) {
        drinking!.add(new Drinking.fromJson(v));
      });
    }
    if (json['kids'] != null) {
      kids = <Kids>[];
      json['kids'].forEach((v) {
        kids!.add(new Kids.fromJson(v));
      });
    }
    if (json['religions'] != null) {
      religions = <Religions>[];
      json['religions'].forEach((v) {
        religions!.add(new Religions.fromJson(v));
      });
    }
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    if (json['lookingFor'] != null) {
      lookingFor = <LookingFor>[];
      json['lookingFor'].forEach((v) {
        lookingFor!.add(new LookingFor.fromJson(v));
      });
    }
    if (json['causesAndCommunities'] != null) {
      causesAndCommunities = <CausesAndCommunities>[];
      json['causesAndCommunities'].forEach((v) {
        causesAndCommunities!.add(new CausesAndCommunities.fromJson(v));
      });
    }
    if (json['prompts'] != null) {
      prompts = <Prompts>[];
      json['prompts'].forEach((v) {
        prompts!.add(new Prompts.fromJson(v));
      });
    }
    if (json['defaultMessages'] != null) {
      defaultMessages = <DefaultMessages>[];
      json['defaultMessages'].forEach((v) {
        defaultMessages!.add(new DefaultMessages.fromJson(v));
      });
    }
    if (json['profile_pics'] != null) {
      profilePics = <ProfilePics>[];
      json['profile_pics'].forEach((v) {
        profilePics!.add(new ProfilePics.fromJson(v));
      });
    }
    starSign = json['starSign'] != null
        ? new Qualities.fromJson(json['starSign'])
        : null;
    education = json['education'] != null
        ? Education.fromJson(json['education'])
        : null;
    if (json['works'] != null) {
      works = <Works>[];
      json['works'].forEach((v) {
        works!.add(new Works.fromJson(v));
      });
    }
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    educationLevel = json['educationLevel'];
    exercise = json['exercise'];
    haveKids = json['haveKids'];
    if (json['genderIdentities'] != null) {
      genderIdentities = <GenderIdentities>[];
      json['genderIdentities'].forEach((v) {
        genderIdentities!.add(new GenderIdentities.fromJson(v));
      });
    }
    smoking = json['smoking'];
    politics = json['politics'];
    hometown = json['hometown'];
    height = json['height'];
    if (json['spokenLanguages'] != null) {
      spokenLanguages = <Language>[];
      json['spokenLanguages'].forEach((v) {
        spokenLanguages!.add(new Language.fromJson(v));
      });
    }
    createdByAdminId = json['createdByAdminId'];
    if (json['modes'] != null) {
      modes = <Mode>[];
      json['modes'].forEach((v) {
        modes!.add(new Mode.fromJson(v));
      });
    }
    if (json['relationships'] != null) {
      relationships = <Relationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(new Relationships.fromJson(v));
      });
    }
    if (json['industries'] != null) {
      industries = <Industries>[];
      json['industries'].forEach((v) {
        industries!.add(new Industries.fromJson(v));
      });
    }
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(new Experiences.fromJson(v));
      });
    }
    newToArea = json['newToArea'];
    snoozStatus = json['snoozStatus'] != null
        ? new SnoozStatus.fromJson(json['snoozStatus'])
        : null;
    travelMode = json['travelMode'] != null
        ? new TravelMode.fromJson(json['travelMode'])
        : null;
    if (json['purchasedPlans'] != null) {
      purchasedPlans = <PurchasedPlans>[];
      json['purchasedPlans'].forEach((v) {
        purchasedPlans!.add(new PurchasedPlans.fromJson(v));
      });
    }
    profileCompletion = json['profileCompletion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['pronouns'] = this.pronouns;
    data['dob'] = this.dob;
    data['showOnProfile'] = this.showOnProfile;
    data['headLine'] = this.headLine;
    data['termsAndConditions'] = this.termsAndConditions;
    data['isVerified'] = this.isVerified;
    if (this.qualities != null) {
      data['qualities'] = this.qualities!.map((v) => v.toJson()).toList();
    }
    if (this.drinking != null) {
      data['drinking'] = this.drinking!.map((v) => v.toJson()).toList();
    }
    if (this.kids != null) {
      data['kids'] = this.kids!.map((v) => v.toJson()).toList();
    }
    if (this.religions != null) {
      data['religions'] = this.religions!.map((v) => v.toJson()).toList();
    }
    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    if (this.lookingFor != null) {
      data['lookingFor'] = this.lookingFor!.map((v) => v.toJson()).toList();
    }
    if (this.causesAndCommunities != null) {
      data['causesAndCommunities'] =
          this.causesAndCommunities!.map((v) => v.toJson()).toList();
    }
    if (this.prompts != null) {
      data['prompts'] = this.prompts!.map((v) => v.toJson()).toList();
    }
    if (this.defaultMessages != null) {
      data['defaultMessages'] =
          this.defaultMessages!.map((v) => v.toJson()).toList();
    }
    if (this.profilePics != null) {
      data['profile_pics'] = this.profilePics!.map((v) => v.toJson()).toList();
    }
    if (this.starSign != null) {
      data['starSign'] = this.starSign!.toJson();
    }
    if (education != null) {
      data['education'] = education!.toJson();
    }
    if (this.works != null) {
      data['works'] = this.works!.map((v) => v.toJson()).toList();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['educationLevel'] = this.educationLevel;
    data['exercise'] = this.exercise;
    data['haveKids'] = this.haveKids;
    if (this.genderIdentities != null) {
      data['genderIdentities'] =
          this.genderIdentities!.map((v) => v.toJson()).toList();
    }
    data['smoking'] = this.smoking;
    data['politics'] = this.politics;
    data['hometown'] = this.hometown;
    data['height'] = this.height;
    if (this.spokenLanguages != null) {
      data['spokenLanguages'] =
          this.spokenLanguages!.map((v) => v.toJson()).toList();
    }
    data['createdByAdminId'] = this.createdByAdminId;
    if (this.modes != null) {
      data['modes'] = this.modes!.map((v) => v.toJson()).toList();
    }
    if (this.relationships != null) {
      data['relationships'] =
          this.relationships!.map((v) => v.toJson()).toList();
    }
    if (this.industries != null) {
      data['industries'] = this.industries!.map((v) => v.toJson()).toList();
    }
    if (this.experiences != null) {
      data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
    }
    data['newToArea'] = this.newToArea;
    if (this.snoozStatus != null) {
      data['snoozStatus'] = this.snoozStatus!.toJson();
    }
    if (this.travelMode != null) {
      data['travelMode'] = this.travelMode!.toJson();
    }
    if (this.purchasedPlans != null) {
      data['purchasedPlans'] =
          this.purchasedPlans!.map((v) => v.toJson()).toList();
    }
    data['profileCompletion'] = this.profileCompletion;
    return data;
  }
}

class Qualities {
  int? id;
  String? name;

  Qualities({this.id, this.name});

  Qualities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Drinking {
  int? id;
  String? preference;

  Drinking({this.id, this.preference});

  Drinking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    preference = json['preference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['preference'] = this.preference;
    return data;
  }
}

class Kids {
  int? id;
  String? kids;

  Kids({this.id, this.kids});

  Kids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kids = json['kids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kids'] = this.kids;
    return data;
  }
}

class Religions {
  int? id;
  String? religion;

  Religions({this.id, this.religion});

  Religions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religion = json['religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['religion'] = this.religion;
    return data;
  }
}

class Interests {
  int? id;
  String? interests;

  Interests({this.id, this.interests});

  Interests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interests = json['interests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['interests'] = this.interests;
    return data;
  }
}

class LookingFor {
  int? id;
  String? value;

  LookingFor({this.id, this.value});

  LookingFor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

class CausesAndCommunities {
  int? id;
  String? causesAndCommunities;

  CausesAndCommunities({this.id, this.causesAndCommunities});

  CausesAndCommunities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    causesAndCommunities = json['causesAndCommunities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['causesAndCommunities'] = this.causesAndCommunities;
    return data;
  }
}

class DefaultMessages {
  int? id;
  String? message;

  DefaultMessages({this.id, this.message});

  DefaultMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    return data;
  }
}

class ProfilePics {
  int? id;
  String? imagePath;

  ProfilePics({this.id, this.imagePath});

  ProfilePics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class Works {
  int? id;
  String? title;

  Works({this.id, this.title});

  Works.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? name;

  Location({this.latitude, this.longitude, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    if (json['latitude'] != null) {
      latitude = (json['latitude'] as num).toDouble();
    }
    if (json['longitude'] != null) {
      longitude = (json['longitude'] as num).toDouble();
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    return data;
  }
}

class Relationships {
  int? id;
  String? relation;

  Relationships({this.id, this.relation});

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relation'] = this.relation;
    return data;
  }
}

class Industries {
  int? id;
  String? industry;

  Industries({this.id, this.industry});

  Industries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['industry'] = this.industry;
    return data;
  }
}

class Experiences {
  int? id;
  String? experience;

  Experiences({this.id, this.experience});

  Experiences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['experience'] = this.experience;
    return data;
  }
}
class SnoozStatus {
  bool? snooz;
  bool? incognito;
  String? updatedAt; // Changed from Null? to String?

  SnoozStatus({this.snooz, this.incognito, this.updatedAt});

  SnoozStatus.fromJson(Map<String, dynamic> json) {
    snooz = json['snooz'];
    incognito = json['incognito'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['snooz'] = snooz;
    data['incognito'] = incognito;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class TravelMode {
  bool? enabled;
  String? location; // Changed from Null? to String?
  String? updatedAt; // Changed from Null? to String?

  TravelMode({this.enabled, this.location, this.updatedAt});

  TravelMode.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    location = json['location'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    data['location'] = location;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Prompts {
  int? id;
  String? prompt;
  String? response; // Changed from Null? to String?

  Prompts({this.id, this.prompt, this.response});

  Prompts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prompt'] = prompt;
    data['response'] = response;
    return data;
  }
}

class PurchasedPlans {
  int? id;
  int? planId;
  String? status;
  String? purchaseDate;
  String? expiryDate;
  dynamic plan; // Changed from Null? to dynamic

  PurchasedPlans(
      {this.id,
        this.planId,
        this.status,
        this.purchaseDate,
        this.expiryDate,
        this.plan});

  PurchasedPlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['planId'];
    status = json['status'];
    purchaseDate = json['purchaseDate'];
    expiryDate = json['expiryDate'];
    plan = json['plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['planId'] = planId;
    data['status'] = status;
    data['purchaseDate'] = purchaseDate;
    data['expiryDate'] = expiryDate;
    data['plan'] = plan;
    return data;
  }
}

class Language {
  int? id;
  String? name;

  Language({this.id, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
class GenderIdentities {
  int? id;
  String? value;
  String? createdAt;
  String? updatedAt;
  UserGenders? userGenders;

  GenderIdentities({
    this.id,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.userGenders,
  });

  GenderIdentities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userGenders = json['user_genders'] != null
        ? UserGenders.fromJson(json['user_genders'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userGenders != null) {
      data['user_genders'] = userGenders!.toJson();
    }
    return data;
  }

  GenderIdentities copyWith({
    int? id,
    String? value,
    String? createdAt,
    String? updatedAt,
    UserGenders? userGenders,
  }) {
    return GenderIdentities(
      id: id ?? this.id,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userGenders: userGenders ?? this.userGenders,
    );
  }

  static GenderIdentities initial() {
    return GenderIdentities();
  }
}
class UserGenders {
  int? userId;
  int? genderId;

  UserGenders({this.userId, this.genderId});

  UserGenders.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    genderId = json['gender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['gender_id'] = genderId;
    return data;
  }

  UserGenders copyWith({
    int? userId,
    int? genderId,
  }) {
    return UserGenders(
      userId: userId ?? this.userId,
      genderId: genderId ?? this.genderId,
    );
  }

  static UserGenders initial() {
    return UserGenders();
  }
}
class Mode {
  final int id;
  final String value;

  Mode({required this.id, required this.value});

  factory Mode.fromJson(Map<String, dynamic> json) {
    return Mode(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
class Education {
  int? id;
  String? institution;
  int? gradYear;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Education({
    this.id,
    this.institution,
    this.gradYear,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institution = json['institution'];
    gradYear = json['gradYear'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution'] = institution;
    data['gradYear'] = gradYear;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Education copyWith({
    int? id,
    String? institution,
    int? gradYear,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Education(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      gradYear: gradYear ?? this.gradYear,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Education initial() {
    return Education();
  }
}



