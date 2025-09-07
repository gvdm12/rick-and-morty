import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tz/bloc/person_bloc.dart';
import 'package:flutter_tz/bloc/person_event.dart';
import 'package:flutter_tz/bloc/person_state.dart';
import 'package:flutter_tz/widgets/person_card.dart';

class PersonsPage extends StatefulWidget {
  final PersonBloc personBloc;
  const PersonsPage({super.key, required this.personBloc});

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!widget.personBloc.isFetching) {
          widget.personBloc.add(LoadPersons());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      bloc: widget.personBloc,
      builder: (context, state) {
        if (state is PersonLoading && widget.personBloc.allPersons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PersonLoaded || state is PersonLoading) {
          final persons = widget.personBloc.allPersons;
          final favorites = state is PersonLoaded ? state.favorites : [];
          return ListView.builder(
            controller: _scrollController,
            itemCount: persons.length + 1,
            itemBuilder: (context, index) {
              if (index == persons.length) {
                return widget.personBloc.isFetching
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final person = persons[index];
              final isFav = favorites.any((p) => p.id == person.id);
              return PersonCard(
                person: person,
                isFavorite: isFav,
                onFavorite: () {
                  widget.personBloc.add(OnFavorite(person));
                },
              );
            },
          );
        } else if (state is PersonError) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
