import 'dart:convert';

import 'package:start_invest/models/founder_model.dart';

class Startup {
  final int? id;
  final String name;
  final String tagline;
  final String description;
  final String sector;
  final String funding;
  final String location;
  final String date;
  final String website;
  final int fundingGoal;
  final List<Founder> founders;

  Startup({
    this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.sector,
    required this.funding,
    required this.location,
    required this.date,
    required this.website,
    required this.fundingGoal,
    required this.founders,
  }) : assert(founders.isNotEmpty, 'Founders list cannot be empty');

  // Convert a Startup object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'sector': sector,
      'funding': funding,
      'location': location,
      'date': date,
      'website': website,
      'fundingGoal': fundingGoal,
      // Store founders as a JSON string in the database
      'founders': jsonEncode(founders.map((f) => f.toMap()).toList()),
    };
  }

  // Create a Startup object from a map (database row)
  factory Startup.fromMap(Map<String, dynamic> map) {
    // Decode the JSON string back into a list of Founder objects
    List<dynamic> founderList = jsonDecode(map['founders']);
    List<Founder> founders =
        founderList.map((f) => Founder.fromMap(f)).toList();

    return Startup(
      id: map['id'],
      name: map['name'],
      tagline: map['tagline'],
      description: map['description'],
      sector: map['sector'],
      funding: map['funding'],
      location: map['location'],
      date: map['date'],
      website: map['website'],
      fundingGoal: map['fundingGoal'],
      founders: founders,
    );
  }

  // Create a Startup object from JSON (asset file)
  factory Startup.fromJson(Map<String, dynamic> json) {
    List<dynamic> founderList = json['founders'];
    List<Founder> founders =
        founderList.map((f) => Founder.fromJson(f)).toList();

    return Startup(
      name: json['name'],
      tagline: json['tagline'],
      description: json['description'],
      sector: json['sector'],
      funding: json['funding'],
      location: json['location'],
      date: json['date'],
      website: json['website'],
      fundingGoal: json['fundingGoal'],
      founders: founders,
    );
  }

  @override
  String toString() {
    return 'Startup{id: $id, name: $name, tagline: $tagline, sector: $sector, funding: $funding, location: $location, fundingGoal: $fundingGoal, founders: $founders}';
  }
}
