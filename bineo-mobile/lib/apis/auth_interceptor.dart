import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String subscriptionKey;
  String _token = '';
  final Future<Response> Function(RequestOptions) _refreshToken;

  AuthInterceptor(this.subscriptionKey, this._refreshToken);

  void setToken(String token) {
    _token = token;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({'Content-Type': 'application/json'});
    options.headers.addAll({'subscription-key': subscriptionKey});
    if (_token.isNotEmpty) {
      options.headers.addAll({'Authorization': '$_token'});
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await _refreshToken(err.requestOptions);
        return handler.resolve(response);
      } catch (err) {
        print('Refresh Token Failed: ${err.toString()}');
      }
    }
    return handler.next(err);
  }
}
