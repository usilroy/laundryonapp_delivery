class AuthResponse {
  final int driverId;
  final String accessToken;
  final String tokenType;

  AuthResponse(
      {required this.driverId,
      required this.accessToken,
      required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      driverId: json['driver_id'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}
