import 'dart:convert';
import 'dart:io';

import 'package:demo_bloc/cats.dart';
import 'package:http/http.dart' as http;

abstract class CatsRepository {
  Future<List<Cats>> getCats();
}

class SampleCatsRepository implements CatsRepository {
  final baseUrl = "https://hwasampleapi.firebaseio.com/http.json";
  @override
  Future<List<Cats>> getCats() async {
    final response = await http.get(Uri.parse(baseUrl));
    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonBody = jsonDecode(response.body) as List;
        return jsonBody.map((e) => Cats.fromJson(e)).toList();
      default:
        throw NetworkError(
            statusCode: response.statusCode.toString(), message: response.body);
    }
  }
}

class NetworkError implements Exception {
  final String statusCode;
  final String message;

  NetworkError({
    required this.statusCode,
    required this.message,
  });
}
