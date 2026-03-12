import 'delivery_model.dart';

class RideModel {
  final int id;
  final Customer customer;
  final Map<String, dynamic>? driver;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String publicId;
  final ServiceType serviceType;
  final VehicleType vehicleType;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropoffAddress;
  final double dropoffLat;
  final double dropoffLng;
  final double weight;
  final String description;
  final String specialInstruction;
  final String sensitivityLevel;
  final bool fragile;
  final DateTime? scheduledAt;
  final PaymentMethod paymentMethod;
  final String price;
  final Map<String, dynamic> serviceData;
  final Map<String, dynamic> priceBreakdown;
  final String verificationPin;
  final double? driverLastLat;
  final double? driverLastLng;
  final DateTime? driverLastUpdatedAt;
  final DateTime? estimateArrivalTime;
  final Status status;

  RideModel({
    required this.id,
    required this.customer,
    this.driver,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    required this.publicId,
    required this.serviceType,
    required this.vehicleType,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.weight,
    required this.description,
    required this.specialInstruction,
    required this.sensitivityLevel,
    required this.fragile,
    this.scheduledAt,
    required this.paymentMethod,
    required this.price,
    required this.serviceData,
    required this.priceBreakdown,
    required this.verificationPin,
    this.driverLastLat,
    this.driverLastLng,
    this.driverLastUpdatedAt,
    this.estimateArrivalTime,
    required this.status,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      customer: Customer.fromJson(json['customer']),
      driver: json['driver'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isDeleted: json['is_deleted'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      publicId: json['public_id'],
      serviceType: ServiceTypeHelper.fromJson(json['service_type']),
      vehicleType: VehicleTypeHelper.fromJson(json['vehicle_type']),
      pickupAddress: json['pickup_address'],
      pickupLat: (json['pickup_lat'] as num).toDouble(),
      pickupLng: (json['pickup_lng'] as num).toDouble(),
      dropoffAddress: json['dropoff_address'],
      dropoffLat: (json['dropoff_lat'] as num).toDouble(),
      dropoffLng: (json['dropoff_lng'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      description: json['description'],
      specialInstruction: json['special_instruction'],
      sensitivityLevel: json['sensitivity_level'],
      fragile: json['fragile'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'])
          : null,
      paymentMethod: PaymentMethodHelper.fromJson(json['payment_method']),
      price: json['price'],
      serviceData: json['service_data'] ?? {},
      priceBreakdown: json['price_breakdown'] ?? {},
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
      status: StatusHelper.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer.toJson(),
      'driver': driver,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
      'public_id': publicId,
      'service_type': ServiceTypeHelper.toJson(serviceType),
      'vehicle_type': VehicleTypeHelper.toJson(vehicleType),
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
      'service_data': serviceData,
      'price_breakdown': priceBreakdown,
      'verification_pin': verificationPin,
      'driver_last_lat': driverLastLat,
      'driver_last_lng': driverLastLng,
      'driver_last_updated_at': driverLastUpdatedAt?.toIso8601String(),
      'estimate_arrival_time': estimateArrivalTime?.toIso8601String(),
      'status': StatusHelper.toJson(status),
    };
  }
}
