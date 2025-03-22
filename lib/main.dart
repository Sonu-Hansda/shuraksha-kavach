import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_event.dart';
import 'package:shurakhsa_kavach/blocs/address/address_bloc.dart';
import 'package:shurakhsa_kavach/blocs/police/police_bloc.dart';
import 'package:shurakhsa_kavach/core/theme/app_theme.dart';
import 'package:shurakhsa_kavach/pages/auth/landing_page.dart';
import 'package:shurakhsa_kavach/pages/auth/login_page.dart';
import 'package:shurakhsa_kavach/pages/auth/register_page.dart';
import 'package:shurakhsa_kavach/pages/home/home_page.dart';
import 'package:shurakhsa_kavach/pages/police/police_screen.dart';
import 'package:shurakhsa_kavach/pages/splash/splash_screen.dart';
import 'package:shurakhsa_kavach/repositories/auth_repository.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize repositories
  final authRepository = AuthRepository();
  final databaseRepository = DatabaseRepository();

  runApp(MyApp(
    prefs: prefs,
    authRepository: authRepository,
    databaseRepository: databaseRepository,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final AuthRepository authRepository;
  final DatabaseRepository databaseRepository;

  const MyApp({
    super.key,
    required this.prefs,
    required this.authRepository,
    required this.databaseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            prefs: prefs,
            authRepository: authRepository,
            databaseRepository: databaseRepository,
          )..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<AddressBloc>(
          create: (context) => AddressBloc(
            databaseRepository: databaseRepository,
          ),
        ),
        BlocProvider<PoliceBloc>(
          create: (context) => PoliceBloc(
            databaseRepository: databaseRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shurakhsa Kavach',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/landing': (context) => const LandingPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/police': (context) => const PoliceScreen(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
