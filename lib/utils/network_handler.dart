import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHandler {
  final String baseURL;

  NetworkHandler({this.baseURL});

  Future<Map<String, String>> get defaultHeaders async {
    //String token = await TokenManager.instance.getToken();

    Map<String, String> headers = {"Content-Type": "application/json"};
    return headers;
  }

  dynamic formatResponse(dynamic data) {
    return data;
  }

  dynamic extractResponse(dynamic response) {
    response = response as http.Response;
    if (response.statusCode >= 400) {
      return null;
    }
    try {
      return formatResponse(json.decode(response.body));
    } catch (e) {
      return response.body;
    }
  }

  formatURL(String url, {String method: ''}) {
    assert(!url.startsWith("/"));
    return baseURL + url;
  }

  Future<dynamic> get(String url,
      {Map<String, String> additionalheaders,
      Map<String, dynamic> body,
      Map<String, dynamic> params}) async {
    //url = this.formatURL(url);
    Map<String, String> headers = await defaultHeaders;
    if (additionalheaders != null) {
      headers.addAll(additionalheaders);
    }

    final request = http.Request(
      'GET',
      Uri(
        queryParameters: params,
        path: url,
        scheme: 'http',
        host: '3.7.18.90', //FIXME to change for production
      ),
    );
    print('Print this please');

    request.headers.clear();
    request.headers.addAll(headers);
    if (body != null) request.body = json.encode(body);

    final http.Response r =
        await http.Response.fromStream(await request.send());
    print('no error here');
    print('this is respo - ${r.body}');
    return this.extractResponse(r);
  }

  Future<dynamic> post(String url, Map data) async {
    url = this.formatURL(url);
    Map<String, String> headers = await defaultHeaders;
    print("POST $url with data $data");
    http.Response r = await http.post(Uri.parse(url),
        body: json.encode(data), headers: headers);
    print(r.body);
    print(r.statusCode);
    return this.extractResponse(r);
  }

  Future<dynamic> put(
    String url,
    Map data,
  ) async {
    url = this.formatURL(url);
    Map<String, String> headers = await defaultHeaders;

    http.Response r = await http.put(Uri.parse(url),
        body: json.encode(data), headers: headers);
    print(r.body);
    return this.extractResponse(r);
  }

  Future<dynamic> patch(
    String url,
    Map data,
  ) async {
    url = this.formatURL(url);
    Map<String, String> headers = await defaultHeaders;

    http.Response r = await http.patch(Uri.parse(url),
        body: json.encode(data), headers: headers);
    return this.extractResponse(r);
  }

  Future<dynamic> delete(String url, Map body) async {
    Map<String, String> headers = await defaultHeaders;
    final request = http.Request(
      'DELETE',
      Uri(
        path: url,
        scheme: 'http',
        host: '3.7.18.90', //FIXME to change for production
      ),
    );

    request.headers.clear();
    request.headers.addAll(headers);
    if (body != null) request.body = json.encode(body);

    final http.Response r =
        await http.Response.fromStream(await request.send());
    print('no error here');
    print('this is respo - ${r.statusCode}');
    return this.extractResponse(r);
  }
}
