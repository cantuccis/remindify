import 'package:http/http.dart' as http;

extension IsOk on http.Response {
  bool get ok => (statusCode ~/ 100) == 2;
  bool get badRequest => (statusCode ~/ 100) == 4 || (statusCode ~/ 100) == 5;
  bool get serverError => (statusCode ~/ 100) == 5;
  bool get notFound => statusCode == 404;
  bool get unauthorized => statusCode == 401;
  bool get forbidden => statusCode == 403;
  bool get methodNotAllowed => statusCode == 405;
  bool get requestTimeout => statusCode == 408;
  bool get imATeapot => statusCode == 418;
  bool get serviceUnavailable => statusCode  == 503;
}