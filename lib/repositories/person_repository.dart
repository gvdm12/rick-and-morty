import 'dart:convert';
import 'package:flutter_tz/models/person.dart';
import 'package:flutter_tz/services/api_service.dart';
import 'package:flutter_tz/utils/network.dart';
import 'package:hive/hive.dart';

class PersonRepository {
  final ApiService apiService;
  final String favBoxName = 'favBox';
  final String cacheBoxName = 'cacheBox';

  PersonRepository({required this.apiService});

  // здесь  получение персонажей с оффлайн и кэш поддержкой
  Future<List<Person>> getCharacters({int page = 1}) async {
    var box = Hive.box(cacheBoxName);
    bool online = await hasInternet();

    if (online) {
      try {
        final persons = await apiService.fetchCharacters(page: page);

        List<String> cached = persons
            .map((p) => jsonEncode(p.toJson()))
            .toList();
        await box.put('page_$page', cached);

        return persons;
      } catch (_) {}
    }
    List<Person> cachedPersons = [];
    for (var key in box.keys) {
      List<dynamic>? cached = box.get(key);
      if (cached != null) {
        cachedPersons.addAll(
          cached.map((e) => Person.fromJson(jsonDecode(e))).toList(),
        );
      }
    }

    if (cachedPersons.isNotEmpty) {
      return cachedPersons;
    } else {
      throw ('нет интернета');
    }
  }

  Future<List<Person>> getFavorites() async {
    var box = Hive.box(favBoxName);
    List<dynamic> favList = box.get(favBoxName, defaultValue: []);
    return favList.map((e) => Person.fromJson(jsonDecode(e))).toList();
  }

  Future<void> onFavorite(Person person) async {
    var box = Hive.box(favBoxName);
    List<dynamic> favList = box.get(favBoxName, defaultValue: []);
    List<Person> favorites = favList
        .map((e) => Person.fromJson(jsonDecode(e)))
        .toList();

    if (favorites.any((p) => p.id == person.id)) {
      favorites.removeWhere((p) => p.id == person.id);
    } else {
      favorites.add(person);
    }

    List<String> favJson = favorites
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    await box.put(favBoxName, favJson);
  }
}
