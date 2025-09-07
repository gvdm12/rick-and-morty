import 'package:flutter/material.dart';
import 'package:flutter_tz/models/notifier.dart';
import 'package:flutter_tz/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favBox');
  await Hive.openBox('cacheBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          theme: ThemeData(
            brightness: isDarkMode ? Brightness.light : Brightness.dark,
          ),
        );
      },
    );
  }
}
