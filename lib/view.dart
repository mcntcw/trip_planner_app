import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_planner_app/features/trips/bloc/trips_bloc.dart';
import 'package:trip_planner_app/features/trips/view/screens/trips_screen.dart';
import 'package:trip_planner_app/main.dart';

class MyView extends StatelessWidget {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Plantour',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            // surface: Color.fromARGB(255, 175, 175, 175),
            // primary: Color.fromARGB(255, 43, 43, 43),
            // onSurface: Color.fromARGB(255, 166, 166, 166),
            surface: Color(0xFF1D1D1D),
            primary: Color.fromARGB(255, 179, 179, 179),
            onSurface: Color.fromARGB(255, 20, 20, 20),
            surfaceContainer: Color.fromARGB(255, 3, 3, 3),
            error: Color.fromARGB(255, 114, 44, 44)),
        fontFamily: 'Switzer',
      ),
      home: BlocProvider(
        create: (context) => TripsBloc(googlePlacesRepository: GooglePlacesRepository()),
        child: const TripsScreen(),
      ),
    );
  }
}
