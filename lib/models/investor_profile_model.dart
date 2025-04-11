class InvestorProfileModel {
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

  InvestorProfileModel({
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

  factory InvestorProfileModel.fromJson(Map<String, dynamic> json) {
    return InvestorProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      tagline: json['location'] as String,
      minInvestment: json['location'] as int,
      maxInvestment: json['location'] as int,
      bio: json['location'] as String,
      investmentFocus: json['location'] as List<String>,
      pastInvestments: json['location'] as List<String>,
      activeSince: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'location': location,
      'tagline': tagline,
      'minInvestment': minInvestment,
      'maxInvestment': maxInvestment,
      'bio': bio,
      'investmentFocus': investmentFocus,
      'pastInvestments': pastInvestments,
      'activeSince': activeSince,
    };
  }

  @override
  String toString() {
    return 'InvestorProfileModel(name: $name, email: $email, location: $location, tagline: $tagline, minInvestment: $minInvestment, maxInvestment: $maxInvestment, bio: $bio, investmentFocus: $investmentFocus, pastInvestments: $pastInvestments, activeSince: $activeSince)';
  }
}
