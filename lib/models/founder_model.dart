class FounderModel {
  String name;
  String email;

  FounderModel({required this.name, required this.email});

  factory FounderModel.fromJson(Map<String, dynamic> json) {
    return FounderModel(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }

  @override
  String toString() {
    return 'FounderModel{name: $name, email: $email}';
  }
}
