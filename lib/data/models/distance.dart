import 'dart:convert';

class Dist {
  final num? calculated;

  Dist({
    this.calculated,
  });

  Dist copyWith({
    num? calculated,
  }) =>
      Dist(
        calculated: calculated ?? this.calculated,
      );

  factory Dist.fromRawJson(String str) => Dist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dist.fromJson(Map<String, dynamic> json) => Dist(
        calculated: json["calculated"],
      );

  Map<String, dynamic> toJson() => {
        "calculated": calculated,
      };
}
