import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/launcher_screen/launcher_screen.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

void main() {
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => AuthenticationBloc()),
      RepositoryProvider(create: (_) => LoadingCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade800,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light
        ),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(color: Colors.white)
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blue,
          brightness: Brightness.dark
        )),
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      home: const LauncherScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
