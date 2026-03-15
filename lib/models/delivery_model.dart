// ignore_for_file: prefer_interpolation_to_compose_strings

enum Status {
  pending,
  searching,
  driverAssigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
}

enum ServiceType {
  pickupDelivery,
  wrecker,
  removalTruck,
  cookingGas,
  bike,
  car,
  van,
}

enum VehicleType { car, bike, van, wrecker, removalTruck }

enum PaymentMethod { cash, stripe, lynk, jnMoney }

class StatusHelper {
  static Status fromJson(String json) {
    switch (json) {
      case 'pending':
        return Status.pending;
      case 'searching':
        return Status.searching;
      case 'driver_assigned':
        return Status.driverAssigned;
      case 'picked_up':
        return Status.pickedUp;
      case 'in_transit':
        return Status.inTransit;
      case 'delivered':
        return Status.delivered;
      case 'cancelled':
        return Status.cancelled;
      default:
        throw ArgumentError('Invalid status value');
    }
  }

  static String toJson(Status status) {
    switch (status) {
      case Status.pending:
        return 'pending';
      case Status.searching:
        return 'searching';
      case Status.driverAssigned:
        return 'driver_assigned';
      case Status.pickedUp:
        return 'picked_up';
      case Status.inTransit:
        return 'in_transit';
      case Status.delivered:
        return 'delivered';
      case Status.cancelled:
        return 'cancelled';
    }
  }
}

class ServiceTypeHelper {
  static ServiceType fromJson(String json) {
    switch (json) {
      case 'pickup_delivery':
        return ServiceType.pickupDelivery;
      case 'wrecker':
        return ServiceType.wrecker;
      case 'removal_truck':
        return ServiceType.removalTruck;
      case 'cooking_gas':
        return ServiceType.cookingGas;
      case 'bike':
        return ServiceType.bike;
      case 'car':
        return ServiceType.car;
      case 'van':
        return ServiceType.van;
      default:
        throw ArgumentError('Invalid service type value');
    }
  }

  static String toJson(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.pickupDelivery:
        return 'pickup_delivery';
      case ServiceType.wrecker:
        return 'wrecker';
      case ServiceType.removalTruck:
        return 'removal_truck';
      case ServiceType.cookingGas:
        return 'cooking_gas';
      case ServiceType.bike:
        return 'bike';
      case ServiceType.car:
        return 'car';
      case ServiceType.van:
        return 'van';
    }
  }
}

class VehicleTypeHelper {
  static VehicleType fromJson(String json) {
    switch (json) {
      case 'car':
        return VehicleType.car;
      case 'bike':
        return VehicleType.bike;
      case 'van':
        return VehicleType.van;
      case 'wrecker':
        return VehicleType.wrecker;
      case 'removal_truck':
        return VehicleType.removalTruck;
      default:
        throw ArgumentError('Invalid vehicle type value');
    }
  }

  static String toJson(VehicleType vehicleType) {
    switch (vehicleType) {
      case VehicleType.car:
        return 'car';
      case VehicleType.bike:
        return 'bike';
      case VehicleType.van:
        return 'van';
      case VehicleType.wrecker:
        return 'wrecker';
      case VehicleType.removalTruck:
        return 'removal_truck';
    }
  }
}

class PaymentMethodHelper {
  static PaymentMethod fromJson(String json) {
    switch (json) {
      case 'cash':
        return PaymentMethod.cash;
      case 'stripe':
        return PaymentMethod.stripe;
      case 'lynk':
        return PaymentMethod.lynk;
      case 'jn_money':
        return PaymentMethod.jnMoney;
      default:
        throw ArgumentError('Invalid payment method value');
    }
  }

  static String toJson(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.stripe:
        return 'stripe';
      case PaymentMethod.lynk:
        return 'lynk';
      case PaymentMethod.jnMoney:
        return 'jn_money';
    }
  }
}

class User {
  final int userId;
  final String name;
  final String phone;
  final String profileImage;

  User({
    required this.userId,
    required this.name,
    required this.phone,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      phone: json['phone'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'phone': phone,
      'profile_image': profileImage,
    };
  }
}

class Driver extends User {
  final int? ratingCount;
  final double? averageRating;
  final String? vehicleType;
  final String? brand;
  final String? model;
  final String? color;
  final String? registrationNumber;

  Driver({
    required int userId,
    required String name,
    required String phone,
    required String profileImage,
    this.ratingCount,
    this.averageRating,
    this.vehicleType,
    this.brand,
    this.model,
    this.color,
    this.registrationNumber,
  }) : super(
         userId: userId,
         name: name,
         phone: phone,
         profileImage: profileImage,
       );

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      userId: json['user_id'],
      name: json['name'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      ratingCount: json['rating_count'],
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      vehicleType: json['vehicle_type'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      registrationNumber: json['registration_number'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      'rating_count': ratingCount,
      'average_rating': averageRating,
      'vehicle_type': vehicleType,
      'brand': brand,
      'model': model,
      'color': color,
      'registration_number': registrationNumber,
    });
    return map;
  }
}

class DeliveryModel {
  final int id;
  final String publicId;
  Status status;
  final ServiceType serviceType;
  final VehicleType? vehicleType;
  final String pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String dropoffAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final double? weight;
  final String? description;
  final String? specialInstruction;
  final String? sensitivityLevel;
  final bool? fragile;
  final DateTime? scheduledAt;
  final PaymentMethod paymentMethod;
  final String price;
  final User customer;
  final Driver? driver;
  final Map<String, dynamic> priceBreakdown;
  final Map<String, dynamic> serviceData;
  final String? verificationPin;
  final double? driverLastLat;
  final double? driverLastLng;
  final DateTime? driverLastUpdatedAt;
  final DateTime? estimateArrivalTime;
  final bool? isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryModel({
    required this.id,
    required this.publicId,
    required this.status,
    required this.serviceType,
    this.vehicleType,
    required this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    required this.dropoffAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.weight,
    this.description,
    this.specialInstruction,
    this.sensitivityLevel,
    this.fragile,
    this.scheduledAt,
    required this.paymentMethod,
    required this.price,
    required this.customer,
    this.driver,
    required this.priceBreakdown,
    required this.serviceData,
    this.verificationPin,
    this.driverLastLat,
    this.driverLastLng,
    this.driverLastUpdatedAt,
    this.estimateArrivalTime,
    this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    final model = DeliveryModel(
      id: json['id'],
      publicId: json['public_id'],
      status: StatusHelper.fromJson(json['status']),
      serviceType: ServiceTypeHelper.fromJson(json['service_type']),
      vehicleType: (json['vehicle_type'] == null || json['vehicle_type'] == '')
          ? null
          : VehicleTypeHelper.fromJson(json['vehicle_type']),
      pickupAddress: json['pickup_address'],
      pickupLat: (json['pickup_lat'] as num?)?.toDouble(),
      pickupLng: (json['pickup_lng'] as num?)?.toDouble(),
      dropoffAddress: json['dropoff_address'],
      dropoffLat: (json['dropoff_lat'] as num?)?.toDouble(),
      dropoffLng: (json['dropoff_lng'] as num?)?.toDouble(),
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      description: json['description'],
      specialInstruction: json['special_instruction'],
      sensitivityLevel: json['sensitivity_level'],
      fragile: json['fragile'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'])
          : null,
      paymentMethod: PaymentMethodHelper.fromJson(json['payment_method']),
      price: json['price'],
      customer: User.fromJson(json['customer']),
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      priceBreakdown: json['price_breakdown'] ?? {},
      serviceData: json['service_data'] ?? {},
      verificationPin: json['verification_pin'],
      driverLastLat: json['driver_last_lat'] != null
          ? (json['driver_last_lat'] as num).toDouble()
          : null,
      driverLastLng: json['driver_last_lng'] != null
          ? (json['driver_last_lng'] as num).toDouble()
          : null,
      driverLastUpdatedAt: json['driver_last_updated_at'] != null
          ? DateTime.parse(json['driver_last_updated_at'])
          : null,
      estimateArrivalTime: json['estimate_arrival_time'] != null
          ? DateTime.parse(json['estimate_arrival_time'])
          : null,
      isDeleted: json['is_deleted'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'public_id': publicId,
      'status': StatusHelper.toJson(status),
      'service_type': ServiceTypeHelper.toJson(serviceType),
      'vehicle_type': vehicleType == null
          ? null
          : VehicleTypeHelper.toJson(vehicleType!),
      'pickup_address': pickupAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_address': dropoffAddress,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'weight': weight,
      'description': description,
      'special_instruction': specialInstruction,
      'sensitivity_level': sensitivityLevel,
      'fragile': fragile,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'payment_method': PaymentMethodHelper.toJson(paymentMethod),
      'price': price,
      'customer': customer.toJson(),
      'driver': driver?.toJson(),
      'price_breakdown': priceBreakdown,
      'service_data': serviceData,
      'verification_pin': verificationPin,
      'driver_last_lat': driverLastLat,
      'driver_last_lng': driverLastLng,
      'driver_last_updated_at': driverLastUpdatedAt?.toIso8601String(),
      'estimate_arrival_time': estimateArrivalTime?.toIso8601String(),
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
