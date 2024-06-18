class OAuthToken {
  final String tokenType;
  final int expiresIn;
  final int extExpiresIn;
  final String accessToken;

  OAuthToken({
    required this.tokenType,
    required this.expiresIn,
    required this.extExpiresIn,
    required this.accessToken,
  });

  factory OAuthToken.fromMap(Map<String, dynamic> map) {
    return OAuthToken(
      tokenType: map['token_type'] ?? '',
      expiresIn: map['expires_in'] ?? 0,
      extExpiresIn: map['ext_expires_in'] ?? 0,
      accessToken: map['access_token'] ?? '',
    );
  }
}
