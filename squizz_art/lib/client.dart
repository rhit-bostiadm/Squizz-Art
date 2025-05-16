import 'dart:async';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:squizz_art/drawing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Client {
  late String ip;
  final port = 80;

  Client() {
    ip = "137.112.216.124";
    print("IP: $ip");
  }

  // Future<void> setupClient() async {
  //   // ip = await Ipify.ipv4();
    
    
  //   // final request = await client.getUrl(Uri.parse('http://$ip'));
  //   // await request.close();
  //   // client.listen((HttpRequest request) {
  //   //   handleRequest(request);
  //   // });
  // }

  // void handleRequest(HttpRequest request) {
  //   // HttpResponse response;
  //   // switch (request.method) {
  //   //   case 'GET':
  //       // response.headers
  //       request.response.write("This is a test for the Squizz App HTTP server");
  //       request.response.close();
  //   //     break;
  //   // }
  // }

  Future<Drawing> sendDrawing(Drawing drawing) async {
    final response = await http.post(
      Uri.parse('http://$ip'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
      },
      body: jsonEncode(drawing.toJson()),
    );

    print("Oh, ok then.\n");

    if (response.statusCode == 201) {
      return Drawing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to send drawing.');
    }
  }

  Future<void> getNewCanvas(List<Drawing> drawings) async {
    final response = await http.get(
      Uri.parse('http://$ip'),
    );

    if (response.statusCode == 200) {
      if (drawings.isEmpty) {
        return await getNewCanvas(drawings);
      }

      Drawing drawing = Drawing.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      drawings.add(drawing);
      return await getNewCanvas(drawings);
    } else if (response.statusCode == 502) {
      return await getNewCanvas(drawings);
    } else {
      throw Exception('HTTP GET request failed.');
    }
  }
}





