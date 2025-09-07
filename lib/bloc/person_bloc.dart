import 'package:bloc/bloc.dart';
import 'package:flutter_tz/bloc/person_event.dart';
import 'package:flutter_tz/bloc/person_state.dart';
import 'package:flutter_tz/repositories/person_repository.dart';
import 'package:flutter_tz/models/person.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
  int currentPage = 1;
  bool isFetching = false;
  List<Person> allPersons = [];

  PersonBloc(this.repository) : super(PersonLoading()) {
    on<LoadPersons>((event, emit) async {
      if (isFetching) return;
      isFetching = true;

      try {
        final newPersons = await repository.getCharacters(page: currentPage);

        // Онлайн → добавляем уникальных персонажей
        final ids = allPersons.map((e) => e.id).toSet();
        allPersons.addAll(newPersons.where((p) => !ids.contains(p.id)));

        final favorites = await repository.getFavorites();
        emit(PersonLoaded(persons: allPersons, favorites: favorites));

        // Увеличиваем страницу только если онлайн (новые персонажи пришли)
        if (newPersons.isNotEmpty) currentPage++;
      } catch (e) {
        if (allPersons.isNotEmpty) {
          final favorites = await repository.getFavorites();
          emit(PersonLoaded(persons: allPersons, favorites: favorites));
        } else {
          emit(PersonError('нет интернета'));
        }
      } finally {
        isFetching = false;
      }
    });

    on<OnFavorite>((event, emit) async {
      if (state is PersonLoaded) {
        await repository.onFavorite(event.person);
        final favorites = await repository.getFavorites();
        emit(PersonLoaded(persons: allPersons, favorites: favorites));
      }
    });

    on<SortFavoritesName>((event, emit) {
      if (state is PersonLoaded) {
        final currentState = state as PersonLoaded;
        final sortedFavorites = List<Person>.from(currentState.favorites)
          ..sort(
            (a, b) => event.sortAscending
                ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
                : b.name.toLowerCase().compareTo(a.name.toLowerCase()),
          );

        emit(
          PersonLoaded(
            persons: currentState.persons,
            favorites: sortedFavorites,
          ),
        );
      }
    });

    on<SortFavoritesReset>((event, emit) async {
      if (state is PersonLoaded) {
        final favorites = await repository.getFavorites();
        emit(PersonLoaded(persons: allPersons, favorites: favorites));
      }
    });
  }
}

// class PersonBloc extends Bloc<PersonEvent, PersonState> {
//   final PersonRepository repository;

//   PersonBloc(this.repository) : super(PersonLoading()) {
//     on<LoadPersons>((event, emit) async {
//       try {
//         final persons = await repository.getCharacters();
//         final favorites = await repository.getFavorites();
//         emit(PersonLoaded(persons: persons, favorites: favorites));
//       } catch (e) {
//         emit(PersonError(e.toString()));
//       }
//     });

//     on<OnFavorite>((event, emit) async {
//       if (state is PersonLoaded) {
//         final currentState = state as PersonLoaded;
//         repository.onFavorite(event.person);
//         final favorites = await repository.getFavorites();
//         emit(PersonLoaded(persons: currentState.persons, favorites: favorites));
//       }
//     });
//   }
// }
