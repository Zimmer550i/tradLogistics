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

enum VehicleType {
  car,
  bike,
  van,
  wrecker,
  removalTruck,
}

enum PaymentMethod {
  cash,
  stripe,
  lynk,
  jnMoney,
}

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

class Customer {
  final int userId;
  final String name;
  final String phone;
  final String profileImage;

  Customer({
    required this.userId,
    required this.name,
    required this.phone,
    required this.profileImage,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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

class DeliveryModel {
  final int id;
  final String publicId;
  final Status status;
  final ServiceType serviceType;
  final VehicleType? vehicleType;
  final String pickupAddress;
  final String dropoffAddress;
  final DateTime? scheduledAt;
  final PaymentMethod paymentMethod;
  final String price;
  final Customer customer;
  final String? driver;
  final Map<String, dynamic> priceBreakdown;
  final Map<String, dynamic> serviceData;
  final double? driverLastLat;
  final double? driverLastLng;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryModel({
    required this.id,
    required this.publicId,
    required this.status,
    required this.serviceType,
    this.vehicleType,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.scheduledAt,
    required this.paymentMethod,
    required this.price,
    required this.customer,
    this.driver,
    required this.priceBreakdown,
    required this.serviceData,
    this.driverLastLat,
    this.driverLastLng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      publicId: json['public_id'],
      status: StatusHelper.fromJson(json['status']),
      serviceType: ServiceTypeHelper.fromJson(json['service_type']),
      vehicleType: (json['vehicle_type'] == null || json['vehicle_type'] == '')
          ? null
          : VehicleTypeHelper.fromJson(json['vehicle_type']),
      pickupAddress: json['pickup_address'],
      dropoffAddress: json['dropoff_address'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'])
          : null,
      paymentMethod: PaymentMethodHelper.fromJson(json['payment_method']),
      price: json['price'],
      customer: Customer.fromJson(json['customer']),
      driver: json['driver'],
      priceBreakdown: json['price_breakdown'] ?? {},
      serviceData: json['service_data'] ?? {},
      driverLastLat: json['driver_last_lat'],
      driverLastLng: json['driver_last_lng'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'public_id': publicId,
      'status': StatusHelper.toJson(status),
      'service_type': ServiceTypeHelper.toJson(serviceType),
      'vehicle_type': vehicleType == null ? null : VehicleTypeHelper.toJson(vehicleType!),
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'payment_method': PaymentMethodHelper.toJson(paymentMethod),
      'price': price,
      'customer': customer.toJson(),
      'driver': driver,
      'price_breakdown': priceBreakdown,
      'service_data': serviceData,
      'driver_last_lat': driverLastLat,
      'driver_last_lng': driverLastLng,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}