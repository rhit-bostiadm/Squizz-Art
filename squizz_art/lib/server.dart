import 'dart:io';
import 'package:dart_ipify/dart_ipify.dart';

class Server {
  late HttpServer server;
  late String ip;
  final port = 80;

  Future<void> setupServer() async {
    ip = await Ipify.ipv4();
    server = await HttpServer.bind(ip, port);
    print("IP: $ip");
    server.listen((HttpRequest request) {
      handleRequest(request);
    });
  }

  void handleRequest(HttpRequest request) {
    request.response.write("This is a test for the Squizz App HTTP server");
    request.response.close();
  }
}





