import 'package:dio/dio.dart';

class FionnerAuthInterceptor extends Interceptor {
  final String basicAuthorizationToken;
  String _token = '';
  final Future<Response> Function(RequestOptions) _refreshToken;

  FionnerAuthInterceptor(this.basicAuthorizationToken, this._refreshToken);

  void setToken(String token) {
    _token = token;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    options.headers.addAll({
      'Authorization': _token.isNotEmpty
          ? 'Bearer ${_token}'
          : 'Basic ${basicAuthorizationToken}'
    });
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
