import 'package:start_invest/models/founder_model.dart';

class StartupModel {
  final String name;
  final String tagline;
  final String description;
  final String sector;
  final String funding;
  final String location;
  final String date;
  final String website;
  final int fundingGoal;
  final List<FounderModel> founders;

  StartupModel({
    required this.name,
    required this.description,
    required this.tagline,
    required this.sector,
    required this.funding,
    required this.location,
    required this.date,
    required this.website,
    required this.fundingGoal,
    required this.founders,
  });

  factory StartupModel.fromJson(Map<String, dynamic> json) {
    return StartupModel(
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      sector: json['sector'] as String,
      funding: json['funding'] as String,
      location: json['location'] as String,
      date: json['date'] as String,
      website: json['website'] as String,
      fundingGoal: json['fundingGoal'] as int,
      founders:
          (json['founders'] as List<dynamic>)
              .map((e) => FounderModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'description': description,
      'sector': sector,
      'funding': funding,
      'location': location,
      'date': date,
      'website': website,
      'fundingGoal': fundingGoal,
      'founders': founders.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'StartupModel{name: $name, tagline: $tagline, description: $description, sector: $sector, funding: $funding, location: $location, date: $date, website: $website, fundingGoal: $fundingGoal, founders: $founders}';
  }
}
