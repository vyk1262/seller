import 'package:flutter/material.dart';
import 'package:trade_seller/auth.dart';
import 'package:trade_seller/constants/colors.dart';
import 'package:trade_seller/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        // primaryColor: AppColors.scaffoldBackground,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        // appBarTheme: const AppBarTheme(
        //   color: AppColors.scaffoldBackground,
        //   titleTextStyle: TextStyle(color: Colors.white),
        // ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.simpleButton,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.elevatedButton,
            foregroundColor: Colors.white,
          ),
        ),
        // floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //   backgroundColor: AppColors.scaffoldBackground,
        // ),
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //   backgroundColor: AppColors.scaffoldBackground,
        // ),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: AuthScreen(),
    );
  }
}
