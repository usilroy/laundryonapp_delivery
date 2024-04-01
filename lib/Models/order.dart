enum OrderStatus {
  placed,
  confirmed,
  transit,
  delivered,
  laundromart_accepted,
  order_created
}

enum GoingTo { launderer, customer }

enum Phase { pickup, dropoff }

enum Type { Laundry, IronOnly, DryCleaning }

class Order {
  double distance;
  double deliveryFee;
  int totalItems;
  double weight;
  Type type;
  String orderId;
  String specialInstructions;
  OrderStatus status;
  GoingTo goingTo;
  Phase phase;
  String fromLocationName;
  String toLocationName;
  String fromLocationAddress;
  String toLocationAddress;
  double fromLat;
  double fromLng;
  double toLat;
  double toLng;
  bool ongoing;

  Order({
    required this.distance,
    required this.deliveryFee,
    required this.totalItems,
    required this.weight,
    required this.type,
    required this.orderId,
    required this.specialInstructions,
    required this.status,
    required this.goingTo,
    required this.phase,
    required this.fromLocationName,
    required this.toLocationName,
    required this.fromLocationAddress,
    required this.toLocationAddress,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.ongoing,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      distance: 0.0,
      deliveryFee: 0.0,
      totalItems: json['details']['items'].values.reduce((a, b) => a + b),
      weight: json['details']['weight'],
      type: _getTypeFromString(json['category']),
      orderId: json['id'].toString(),
      specialInstructions: json['details']['special_instructions'] ?? '',
      status: _getOrderStatusFromString(json['order_status']),
      goingTo: GoingTo.customer,
      phase: Phase.pickup,
      fromLocationName: '',
      toLocationName: '',
      fromLocationAddress: '',
      toLocationAddress: json['customer_address']['full_address'],
      fromLat: json['customer_address']['latitude'],
      fromLng: json['customer_address']['longitude'],
      toLat: 0.0,
      toLng: 0.0,
      ongoing: json['order_status'] != 'delivered',
    );
  }

  static Type _getTypeFromString(String type) {
    switch (type) {
      case 'Laundry':
        return Type.Laundry;
      case 'IronOnly':
        return Type.IronOnly;
      case 'DryCleaning':
        return Type.DryCleaning;
      default:
        throw ArgumentError('Invalid order type: $type');
    }
  }

  static OrderStatus _getOrderStatusFromString(String status) {
    switch (status) {
      case 'placed':
        return OrderStatus.placed;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'transit':
        return OrderStatus.transit;
      case 'delivered':
        return OrderStatus.delivered;
      case 'order_created':
        return OrderStatus.order_created;
      case 'laundromart_accepted':
        return OrderStatus.laundromart_accepted;
      default:
        throw ArgumentError('Invalid order status: $status');
    }
  }
}
