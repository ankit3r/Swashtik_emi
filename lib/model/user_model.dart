class User {
  final int id;
  final String name;
  final String? profile;
  final String email;
  final String? emailVerifiedAt;
  final String? state;
  final String? district;
  final String? tehsil;
  final String? village;
  final String? pincode;
  final String? address;
  final int status;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profile,
    this.emailVerifiedAt,
    this.state,
    this.district,
    this.tehsil,
    this.village,
    this.pincode,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile': profile,
      'email_verified_at': emailVerifiedAt,
      'state': state,
      'district': district,
      'tehsil': tehsil,
      'village': village,
      'pincode': pincode,
      'address': address,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      emailVerifiedAt: json['email_verified_at'],
      state: json['state'],
      district: json['district'],
      tehsil: json['tehsil'],
      village: json['village'],
      pincode: json['pincode'],
      address: json['address'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
