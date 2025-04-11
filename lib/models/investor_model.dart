import 'dart:convert';

class InvestorModel {
  final int? id; // Database primary key
  final String name;
  final String tagline;
  final String location;
  final int minInvestment;
  final int maxInvestment;
  final String bio;
  final List<String> investmentFocus;
  final List<String> pastInvestments;
  final String activeSince;
  final String email;

  InvestorModel({
    this.id,
    required this.tagline,
    required this.minInvestment,
    required this.maxInvestment,
    required this.bio,
    required this.investmentFocus,
    required this.pastInvestments,
    required this.activeSince,
    required this.name,
    required this.email,
    required this.location,
  });

  // Corrected factory for JSON parsing
  factory InvestorModel.fromJson(Map<String, dynamic> json) {
    return InvestorModel(
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      tagline: json['tagline'] as String, // Corrected field
      minInvestment: json['minInvestment'] as int, // Corrected field
      maxInvestment: json['maxInvestment'] as int, // Corrected field
      bio: json['bio'] as String, // Corrected field
      // Cast list elements correctly
      investmentFocus:
          (json['investmentFocus'] as List<dynamic>).cast<String>(),
      pastInvestments:
          (json['pastInvestments'] as List<dynamic>).cast<String>(),
      activeSince: json['activeSince'] as String, // Corrected field
    );
  }

  // Factory for creating from database map
  factory InvestorModel.fromMap(Map<String, dynamic> map) {
    return InvestorModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      location: map['location'] as String,
      tagline: map['tagline'] as String,
      minInvestment: map['minInvestment'] as int,
      maxInvestment: map['maxInvestment'] as int,
      bio: map['bio'] as String,
      // Decode JSON strings for lists
      investmentFocus:
          (jsonDecode(map['investmentFocus']) as List<dynamic>).cast<String>(),
      pastInvestments:
          (jsonDecode(map['pastInvestments']) as List<dynamic>).cast<String>(),
      activeSince: map['activeSince'] as String,
    );
  }

  // Convert to map for database (encode lists as JSON strings)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'tagline': tagline,
      'minInvestment': minInvestment,
      'maxInvestment': maxInvestment,
      'bio': bio,
      // Encode lists as JSON strings
      'investmentFocus': jsonEncode(investmentFocus),
      'pastInvestments': jsonEncode(pastInvestments),
      'activeSince': activeSince,
    };
  }

  @override
  String toString() {
    return 'InvestorModel{id: $id, name: $name, email: $email, location: $location, tagline: $tagline, minInvestment: $minInvestment, maxInvestment: $maxInvestment, bio: $bio, investmentFocus: $investmentFocus, pastInvestments: $pastInvestments, activeSince: $activeSince}';
  }
}
