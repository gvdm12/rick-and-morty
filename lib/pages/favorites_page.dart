import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tz/bloc/person_bloc.dart';
import 'package:flutter_tz/bloc/person_event.dart';
import 'package:flutter_tz/bloc/person_state.dart';
import 'package:flutter_tz/widgets/person_card.dart';

enum SortState { none, ascending, descending }

class FavoritesPage extends StatefulWidget {
  final PersonBloc personBloc;
  const FavoritesPage({super.key, required this.personBloc});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  SortState sortState = SortState.none;

  void _toggleSort() {
    setState(() {
      switch (sortState) {
        case SortState.none:
          sortState = SortState.ascending;
          widget.personBloc.add(SortFavoritesName(sortAscending: true));
          break;
        case SortState.ascending:
          sortState = SortState.descending;
          widget.personBloc.add(SortFavoritesName(sortAscending: false));
          break;
        case SortState.descending:
          sortState = SortState.none;
          widget.personBloc.add(SortFavoritesReset());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Избранное',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: _toggleSort,
            icon: Icon(
              Icons.sort_by_alpha_sharp,
              size: 28,
              fontWeight: FontWeight.w400,
            ),
            tooltip: sortState == SortState.none
                ? 'Сортировать'
                : sortState == SortState.ascending
                ? 'Сортировка A→Z'
                : 'Сортировка Z→A',
          ),
        ],
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        bloc: widget.personBloc,
        builder: (context, state) {
          if (state is PersonLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return Center(child: Text('Нет избранных'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final person = favorites[index];
                return PersonCard(
                  person: person,
                  isFavorite: true,
                  onFavorite: () {
                    widget.personBloc.add(OnFavorite(person));
                  },
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}



//  ElevatedButton.icon(
//                 onPressed: _toggleSort,
//                 icon: Icon(Icons.sort_by_alpha),
//                 label: Text(
//                   sortState == SortState.none
//                       ? 'Сортировать'
//                       : sortState == SortState.ascending
//                       ? 'Сортировка A→Z'
//                       : 'Сортировка Z→A',
//                 ),
//               ),