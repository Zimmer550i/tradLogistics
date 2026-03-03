class UserProfileModel {
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? role;
  final String? businessType;
  final String? businessName;
  final String? businessAddress;
  final String? businessLicense;
  final bool isVerified;
  final String? verifiedAt;

  UserProfileModel({
    required this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.profileImage,
    this.role,
    this.businessType,
    this.businessName,
    this.businessAddress,
    this.businessLicense,
    required this.isVerified,
    this.verifiedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      role: json['role'],
      businessType: json['business_type'],
      businessName: json['business_name'],
      businessAddress: json['business_address'],
      businessLicense: json['business_license'],
      isVerified: json['is_verified'] ?? false,
      verifiedAt: json['verified_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'role': role,
      'business_type': businessType,
      'business_name': businessName,
      'business_address': businessAddress,
      'business_license': businessLicense,
      'is_verified': isVerified,
      'verified_at': verifiedAt,
    };
  }
}
