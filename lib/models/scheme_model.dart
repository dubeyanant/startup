class Scheme {
  final String name;
  final String agencyName;
  final String description;
  final bool isEligible;
  final String link;

  Scheme({
    required this.name,
    required this.agencyName,
    required this.description,
    required this.isEligible,
    required this.link,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      name: json['name'] as String,
      agencyName: json['agencyName'] as String,
      description: json['description'] as String,
      isEligible: json['isEligible'] as bool,
      link: json['link'] as String,
    );
  }
}
