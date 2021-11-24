import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SSLClient {
  final http.Client client;
  SSLClient({required this.client});

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/themoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    Response response = await client.get(url, headers: headers);
    return response;
  }
}
