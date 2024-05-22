import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/partners/collected-data/collected-data_screen.dart';
import 'auth/welcome/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserDetails userDetails;

  const HomeScreen({Key? key, required this.userDetails}) : super(key: key);

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  late UserDetails userDetails;
  @override
  void initState() {
    super.initState();
    userDetails = widget.userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.authState == AuthState.unauthenticated) {
            pushAndRemoveUntil(context, const WelcomeScreen(), false);
          }
        },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 132, 121, 100),
              ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                    'Données collectées',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.data_exploration,
                    color: Color.fromRGBO(0, 100, 100, 1),
                  ),
                ),
                onTap: () {
                  push(context, const CollectedDataScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: pi,
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ) ,
                onTap: () {
                  context.read<AuthenticationBloc>().add(LogoutEvent());
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'HOME',
            style: TextStyle(
              color: isDarkMode(context)
                  ? Colors.grey.shade50
                  : Colors.grey.shade50
            )
          ),
          iconTheme: IconThemeData(
            color: isDarkMode(context)
                ? Colors.grey.shade50
                : Colors.grey.shade50
          ),
          backgroundColor:
          isDarkMode(context)
              ? const Color.fromRGBO(0, 132, 121, 100)
              : const Color.fromRGBO(0, 132, 121, 100),
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}