import 'package:surplus/data/models/location.dart';

class User {
  final String? id;
  final String? profilePic;
  final String? name;
  final String? email;
  final String? phone;
  final String? password;
  final bool? status;
  final int? range;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? devices;
  final Location? location;
  final String? accessToken;
  final bool? isAdmin;

  const User({
    this.id,
    this.profilePic,
    this.name,
    this.email,
    this.phone,
    this.range,
    this.password,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.devices,
    this.location,
    this.accessToken,
    this.isAdmin,
  });

  User copyWith({
    String? id,
    String? profilePic,
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? status,
    int? range,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? devices,
    Location? location,
    String? accessToken,
    bool? isAdmin,
  }) =>
      User(
        id: id ?? this.id,
        profilePic: profilePic ?? this.profilePic,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        range: range ?? this.range,
        password: password ?? this.password,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        devices: devices ?? this.devices,
        location: location ?? this.location,
        accessToken: accessToken ?? this.accessToken,
        isAdmin: isAdmin ?? this.isAdmin,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        profilePic: json["profilePic"],
        email: json["email"],
        phone: json["phone"],
        range: json["range"],
        password: json["password"],
        status: json["status"],
        createdAt: json[
          "createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        devices: json["devices"] == null
            ? []
            : List<String>.from(json["devices"]!.map((x) => x)),
        location: Location.fromJson(json['location'] ?? <String, dynamic>{}),
        accessToken: json["access_token"],
        isAdmin: json['isAdmin'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "profilePic": profilePic,
        "name": name,
        "email": email,
        "phone": phone,
        "range": range,
        "password": password,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "devices":
            devices == null ? [] : List<dynamic>.from(devices!.map((x) => x)),
        'location': location?.toJson(),
        "access_token": accessToken,
        'isAdmin': isAdmin,
      };
}
