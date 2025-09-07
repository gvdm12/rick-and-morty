import 'package:flutter_tz/models/person.dart';

abstract class PersonEvent {}

class LoadPersons extends PersonEvent {}

class OnFavorite extends PersonEvent {
  final Person person;
  OnFavorite(this.person);
}

class SortFavoritesReset extends PersonEvent {}
