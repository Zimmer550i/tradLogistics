
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

  final String? dType;
  final String? balance;
  final int? totalDeliveries;
  final String? totalOnlineHours;

  final String? addressText;
  final String? policeRecord;
  final String? proofOfAddress;
  final String? drivingLicenseNumber;

  final double? locationLat;
  final double? locationLong;

  final String? paymentFrequency;

  final String? totalRating;
  final int? ratingCount;
  final String? averageRating;

  final bool availabilityStatus;
  bool isOnline;

  final bool isVerified;
  final String? verifiedAt;

  final Map<String, dynamic>? extraData;
  final dynamic assignTruck;
  final dynamic driverCompany;

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
    this.dType,
    this.balance,
    this.totalDeliveries,
    this.totalOnlineHours,
    this.addressText,
    this.policeRecord,
    this.proofOfAddress,
    this.drivingLicenseNumber,
    this.locationLat,
    this.locationLong,
    this.paymentFrequency,
    this.totalRating,
    this.ratingCount,
    this.averageRating,
    required this.availabilityStatus,
    required this.isOnline,
    required this.isVerified,
    this.verifiedAt,
    this.extraData,
    this.assignTruck,
    this.driverCompany,
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

      dType: json['d_type'],
      balance: json['balance'],
      totalDeliveries: json['total_deliveries'],
      totalOnlineHours: json['total_online_hours'],

      addressText: json['address_text'],
      policeRecord: json['police_record'],
      proofOfAddress: json['proof_of_address'],
      drivingLicenseNumber: json['driving_license_number'],

      locationLat: json['location_lat'] != null
          ? double.tryParse(json['location_lat'].toString())
          : null,
      locationLong: json['location_long'] != null
          ? double.tryParse(json['location_long'].toString())
          : null,

      paymentFrequency: json['payment_frequency'],

      totalRating: json['total_rating'],
      ratingCount: json['rating_count'],
      averageRating: json['average_rating'],

      availabilityStatus: json['availability_status'] ?? false,
      isOnline: json['is_online'] ?? false,

      isVerified: json['is_verified'] ?? false,
      verifiedAt: json['verified_at'],

      extraData: json['extra_data'],
      assignTruck: json['assign_truck'],
      driverCompany: json['driver_company'],
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

      'd_type': dType,
      'balance': balance,
      'total_deliveries': totalDeliveries,
      'total_online_hours': totalOnlineHours,

      'address_text': addressText,
      'police_record': policeRecord,
      'proof_of_address': proofOfAddress,
      'driving_license_number': drivingLicenseNumber,

      'location_lat': locationLat,
      'location_long': locationLong,

      'payment_frequency': paymentFrequency,

      'total_rating': totalRating,
      'rating_count': ratingCount,
      'average_rating': averageRating,

      'availability_status': availabilityStatus,
      'is_online': isOnline,

      'is_verified': isVerified,
      'verified_at': verifiedAt,

      'extra_data': extraData,
      'assign_truck': assignTruck,
      'driver_company': driverCompany,
    };
  }
}
