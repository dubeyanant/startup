class Founder {
  final String name;
  final String email;

  Founder({required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email};
  }

  factory Founder.fromMap(Map<String, dynamic> map) {
    return Founder(name: map['name'], email: map['email']);
  }

  factory Founder.fromJson(Map<String, dynamic> json) {
    return Founder(name: json['name'], email: json['email']);
  }

  @override
  String toString() {
    return 'Founder{name: $name, email: $email}';
  }
}
