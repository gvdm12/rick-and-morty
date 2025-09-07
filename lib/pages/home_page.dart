import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tz/bloc/person_bloc.dart';
import 'package:flutter_tz/bloc/person_event.dart';
import 'package:flutter_tz/widgets/navbar.dart';
import 'package:flutter_tz/pages/favorites_page.dart';
import 'package:flutter_tz/pages/persons_list_page.dart';
import 'package:flutter_tz/repositories/person_repository.dart';
import 'package:flutter_tz/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late PersonRepository repository;
  late PersonBloc bloc;

  @override
  void initState() {
    super.initState();
    repository = PersonRepository(apiService: ApiService());
    bloc = PersonBloc(repository);
    bloc.add(LoadPersons());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PersonsPage(personBloc: bloc),
      FavoritesPage(personBloc: bloc),
    ];

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        bottomNavigationBar: Navbar(
          onTabChange: (index) => setState(() => _selectedIndex = index),
        ),
        body: pages[_selectedIndex],
      ),
    );
  }
}
