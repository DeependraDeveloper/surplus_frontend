import 'dart:convert';

import 'package:surplus/data/models/location.dart';
import 'package:surplus/data/models/user.dart';

class Chat {
  final String? id;
  final User? from;
  final User? to;
  final ChatPost? post;
  final String? status;
  final List<Message>? messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    this.id,
    this.from,
    this.to,
    this.post,
    this.status,
    this.messages,
    this.createdAt,
    this.updatedAt,
  });

  Chat copyWith({
    String? id,
    User? from,
    User? to,
    ChatPost? post,
    String? status,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Chat(
        id: id ?? this.id,
        from: from ?? this.from,
        to: to ?? this.to,
        post: post ?? this.post,
        status: status ?? this.status,
        messages: messages ?? this.messages,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Chat.fromRawJson(String str) => Chat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
        from: json["from"] == null ? null : User.fromJson(json['from']),
        to: json["from"] == null ? null : User.fromJson(json['to']),
        post: json["post"] == null ? null : ChatPost.fromJson(json["post"]),
        status: json["status"],
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "post": post?.toJson(),
        "status": status,
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Message {
  final String? sender;
  final String? content;
  final DateTime? timestamp;
  final String? id;

  Message({
    this.sender,
    this.content,
    this.timestamp,
    this.id,
  });

  Message copyWith({
    String? sender,
    String? content,
    DateTime? timestamp,
    String? id,
  }) =>
      Message(
        sender: sender ?? this.sender,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        id: id ?? this.id,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: json["sender"],
        content: json["content"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "content": content,
        "timestamp": timestamp?.toIso8601String(),
        "_id": id,
      };
}

class ChatPost {
  final Location? location;
  final String? id;
  final User? userId;
  final String? title;
  final String? description;
  final List<String>? images;
  final List<String>? blessedBy;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatPost({
    this.location,
    this.id,
    this.userId,
    this.title,
    this.blessedBy,
    this.description,
    this.images,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  ChatPost copyWith({
    Location? location,
    String? id,
    User? userId,
    String? title,
    String? description,
    List<String>? images,
    List<String>? blessedBy,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ChatPost(
        location: location ?? this.location,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        blessedBy: blessedBy ?? this.blessedBy,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ChatPost.fromRawJson(String str) =>
      ChatPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatPost.fromJson(Map<String, dynamic> json) => ChatPost(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        id: json["_id"],
        userId: json["userId"] == null ? null : User.fromJson(json["userId"]),
        title: json["title"],
        description: json["description"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        blessedBy: json["blessedBy"] == null
            ? []
            : List<String>.from(json["blessedBy"]!.map((x) => x)),
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "_id": id,
        "userId": userId?.toJson(),
        "title": title,
        "description": description,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "blessedBy": blessedBy == null
            ? []
            : List<dynamic>.from(blessedBy!.map((x) => x)),
        "isDeleted": isDeleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
