
import 'dart:convert';

class Location {
    final String? type;
    final List<double>? coordinates;

    Location({
        this.type,
        this.coordinates,
    });

    Location copyWith({
        String? type,
        List<double>? coordinates,
    }) => 
        Location(
            type: type ?? this.type,
            coordinates: coordinates ?? this.coordinates,
        );

    factory Location.fromRawJson(String str) => Location.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
    };
}
