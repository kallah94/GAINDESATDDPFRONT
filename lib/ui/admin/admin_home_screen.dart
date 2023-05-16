

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/admin/permission/permission_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/user/user_screen.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/welcome/welcome_screen.dart';
import 'package:gaindesat_ddp_client/ui/home.dart';

class AdminHomeScreen extends StatefulWidget {
  final UserDetails userDetails;
  
  const AdminHomeScreen({Key? key, required this.userDetails}) : super(key: key);
  
  @override
  State createState() => _AdminHomeState();
  
}

class _AdminHomeState extends State<AdminHomeScreen> {
  late UserDetails userDetails;
  
  @override
  void initState()  {
    super.initState();
    userDetails = widget.userDetails;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if ((state.authState != AuthState.isAdmin) 
        && (state.authState != AuthState.authenticated)) {
          pushAndRemoveUntil(context, const WelcomeScreen(), false);
        } else if (state.authState != AuthState.isAdmin) {
          pushAndRemoveUntil(context, HomeScreen(userDetails: userDetails), false);
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
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  'Users Management',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Color.fromRGBO(0, 100, 100, 1),
                  ),
                ),
                onTap: () {
                  push(context, const UserScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Partners Management',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.public_outlined,
                    color: Color.fromRGBO(0, 100, 100, 1),
                  ),
                ),
                onTap: () {
                  push(context, const UserScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Users Permissions Management',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.shield_rounded,
                    color: Color.fromRGBO(0, 100, 100, 1),
                  ),
                ),
                onTap: () {
                  push(context, const PermissionScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Users Categories Management',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.category_rounded,
                    color: Color.fromRGBO(0, 100, 100, 1),
                  ),
                ),
                onTap: () {
                  push(context, const UserScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900
                  ),
                ),
                leading: Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ) ,
                onTap: () {
                  context.read<AuthenticationBloc>().add(LogoutEvent());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
              'ADMIN HOME',
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [],
          ),
        ),
      ),
    );
  }
}