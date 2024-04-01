class AuthData {
  final int driverId;
  final String token;
  final String tokenType;

  AuthData({
    required this.driverId,
    required this.token,
    required this.tokenType,
  });

  AuthData.fromJson(Map<String, dynamic> json)
      : driverId = json['driver_id'],
        token = json['access_token'],
        tokenType = json['token_type'];
}
