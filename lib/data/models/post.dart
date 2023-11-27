import 'dart:convert';

import 'package:surplus/data/models/distance.dart';
import 'package:surplus/data/models/location.dart';

class Post {
  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final List<String>? images;
  final List<String>? blessedBy;
  final bool? isDeleted;
  final Location? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Dist? dist;

  Post({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.blessedBy,
    this.images,
    this.isDeleted,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.dist,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<String>? images,
    List<String>? blessedBy,
    bool? isDeleted,
    Location? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    Dist? dist,
  }) =>
      Post(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        blessedBy: blessedBy ?? this.blessedBy,
        isDeleted: isDeleted ?? this.isDeleted,
        location: location ?? this.location,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        dist: dist ?? this.dist,
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      description: json["description"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      blessedBy: json["blessedBy"] == null
          ? []
          : List<String>.from(json["blessedBy"]!.map((x) => x)),
      isDeleted: json["isDeleted"],
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      dist: json["dist"] == null ? null : Dist.fromJson(json["dist"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "blessedBy": blessedBy == null
            ? []
            : List<dynamic>.from(blessedBy!.map((x) => x)),
        "isDeleted": isDeleted,
        "location": location?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "dist": dist?.toJson(),
      };
}
