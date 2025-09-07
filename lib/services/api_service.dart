import 'package:dio/dio.dart';
import '../models/person.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://rickandmortyapi.com/api/character/'),
  );

  Future<List<Person>> fetchCharacters({int page = 1}) async {
    try {
      final response = await _dio.get('', queryParameters: {'page': page});
      List results = response.data['results'];
      return results.map((json) => Person.fromJson(json)).toList();
    } on DioException catch (_) {
      return []; // если API не доступно
    }
  }
}
