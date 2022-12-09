class UserModel {
  String? msg;
  Data? data;

  UserModel({this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Data? data;
  String? token;

  Data({this.data, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data1 {
  String? sId;
  String? email;
  String? password;
  String? displayPicture;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isVerified;
  bool? isLoggedIn;
  List<Locations>? locations;
  String? drivingLicense;
  List<String>? appliedJobs;
  bool? isActive;
  String? fullName;

  Data1(
      {
        this.sId,
        this.email,
        this.password,
        this.displayPicture,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isVerified,
        this.isLoggedIn,
        this.locations,
        this.drivingLicense,
        this.appliedJobs,
        this.isActive,
        this.fullName});

  Data1.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    password = json['password'];
    displayPicture = json['display_picture'];
    phoneNumber = json['phone_number'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isVerified = json['isVerified'];
    isLoggedIn = json['isLoggedIn'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
    drivingLicense = json['driving_license'];
    appliedJobs = json['appliedJobs'].cast<String>();
    isActive = json['isActive'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['display_picture'] = this.displayPicture;
    data['phone_number'] = this.phoneNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isVerified'] = this.isVerified;
    data['isLoggedIn'] = this.isLoggedIn;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    data['driving_license'] = this.drivingLicense;
    data['appliedJobs'] = this.appliedJobs;
    data['isActive'] = this.isActive;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Locations {
  String? sId;
  double? latitude;
  double? longitude;
  String? address;
  String? city;

  Locations({this.sId, this.latitude, this.longitude, this.address, this.city});

  Locations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['city'] = this.city;
    return data;
  }
}