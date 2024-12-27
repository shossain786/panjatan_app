import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panjatan_app/bloc/bloc/sawal_bloc.dart';
import 'package:panjatan_app/repositories/sawal_repository.dart';
import 'package:panjatan_app/screens/irshadat_ali.dart';
import 'package:panjatan_app/screens/view_sawal_screen.dart';
import 'package:panjatan_app/screens/welcome_screen.dart';
import 'db/local_db.dart';
import 'services/api_service.dart';

void main() {
  final apiService = ApiService();
  final localDB = LocalDB.instance;
  final sawalRepository =
      SawalRepository(apiService: apiService, localDB: localDB);

  runApp(MyApp(sawalRepository: sawalRepository));
}

class MyApp extends StatelessWidget {
  final SawalRepository sawalRepository;

  const MyApp({super.key, required this.sawalRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SawalBloc(sawalRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: WelcomeScreen(),
        routes: {
          '/irshadat': (context) => const IrshadatAliScreen(),
          '/sawal': (context) => ViewSawalScreen(),
          // '/profile': (context) => const ProfileScreen(),
          // '/notifications': (context) => const NotificationsScreen(),
          // '/help': (context) => const HelpScreen(),
          // '/about': (context) => const AboutScreen(),
        },
      ),
    );
  }
}
