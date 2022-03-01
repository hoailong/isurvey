import 'package:flutter_isurvey/globals.dart';
import 'package:http/http.dart' as http;

class MyClient extends http.BaseClient {
  http.Client _httpClient = new http.Client();
  Glob _glob = new Glob();

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['imei'] = _glob.imei;
    request.headers['model'] = _glob.model;
    request.headers['deviceid'] = _glob.deviceID;
    if(request.method != 'GET') {
      request.headers['_token'] = 'McQeThWmZq4t7w!z%C*F-JaNdRgUjXn2r5u8x/A?D(G+KbPeShVmYp3s6v9y\$B&E)H@McQfTjWnZr4t7w!z%C*F-JaNdRgUkXp2s5v8x/A?D(G+KbPeShVmYq3t6w9z\$';
    }
    return _httpClient.send(request);
  }
}