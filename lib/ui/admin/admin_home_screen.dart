

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/admin/collected-data/collected-data_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/partner/partner_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/permission/permission_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/sensor/sensor_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/stations/station_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/user/user_screen.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/welcome/welcome_screen.dart';
import 'package:gaindesat_ddp_client/ui/home.dart';
import 'package:gaindesat_ddp_client/ui/profile/profile_screen.dart';
import 'category/category_screen.dart';

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
                  'Users',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
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
                  'Partners',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
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
                  push(context, const PartnerScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Users Permissions',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.security,
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
                  'Users Categories',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
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
                  push(context, const CategoryScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Stations",
                  style: TextStyle(
                    color: isDarkMode(context)
                        ? Colors.black
                        : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                    Icons.place_sharp,
                    color: Color.fromRGBO(0, 100, 100, 1)
                  ),
                ),
                onTap: () {
                  push(context, const StationScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Données collectées",
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                      Icons.map_rounded,
                      color: Color.fromRGBO(0, 100, 100, 1)
                  ),
                ),
                onTap: () {
                  push(context, const CollectedDataScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Capteurs",
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                      Icons.sensors,
                      color: Color.fromRGBO(0, 100, 100, 1)
                  ),
                ),
                onTap: () {
                  push(context, const SensorScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: const Icon(
                      Icons.person,
                      color: Color.fromRGBO(0, 100, 100, 1)
                  ),
                ),
                onTap: () {
                  push(context, const ProfileScreen());
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
          child: GridView.extent(
            maxCrossAxisExtent: 500,
            padding: const EdgeInsets.all(30),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              Container(
                color: Colors.tealAccent,
              ),
              Container(
                color: Colors.tealAccent,
              ),
              Container(
                color: Colors.tealAccent,
              ),
              Container(
                color: Colors.tealAccent,
              ),
              Container(
                color: Colors.tealAccent,
              ),
              Container(
                color: Colors.tealAccent,
              )
            ],
          )
        ),
      ),
    );
  }
}