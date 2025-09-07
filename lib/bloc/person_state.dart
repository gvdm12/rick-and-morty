import 'package:flutter_tz/bloc/person_event.dart';
import 'package:flutter_tz/models/person.dart';

abstract class PersonState {}

class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final List<Person> persons;
  final List<Person> favorites;
  PersonLoaded({required this.persons, required this.favorites});
}

class PersonError extends PersonState {
  final String errorMessage;
  PersonError(this.errorMessage);
}

class SortFavoritesName extends PersonEvent {
  final bool sortAscending;
  SortFavoritesName({this.sortAscending = true});
}
