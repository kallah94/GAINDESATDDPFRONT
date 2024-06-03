

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/admin/collected-data/collected-data_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/parameter/parameter_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/partner/partner_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/permission/permission_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/sensor/sensor_screen.dart';
import 'package:gaindesat_ddp_client/ui/admin/stations/station_map_screen.dart';
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
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade900, Colors.teal.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/moussa.jpeg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  )
                  ]
                )
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
                  child:  Icon(
                    Icons.people_alt_rounded,
                    color: Colors.teal.shade900,
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
                  child:  Icon(
                    Icons.public_outlined,
                    color: Colors.teal.shade900,
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
                  child: Icon(
                    Icons.security,
                    color: Colors.teal.shade900,
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
                  child: Icon(
                    Icons.category_rounded,
                    color: Colors.teal.shade900,
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
                  child: Icon(
                    Icons.place_sharp,
                    color: Colors.teal.shade900
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
                  child: Icon(
                      Icons.data_saver_on,
                      color: Colors.teal.shade900
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
                  child: Icon(
                      Icons.sensors,
                      color: Colors.teal.shade900
                  ),
                ),
                onTap: () {
                  push(context, const SensorScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Position des Stations",
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: Icon(
                      Icons.map,
                      color: Colors.teal.shade900
                  ),
                ),
                onTap: () {
                  push(context, const MapScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  "Paramètres",
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.black
                          : Colors.black
                  ),
                ),
                leading: Transform.rotate(
                  angle: 0,
                  child: Icon(
                      Icons.grain,
                      color: Colors.teal.shade900
                  ),
                ),
                onTap: () {
                  push(context, const ParameterScreen());
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
                  child: Icon(
                      Icons.person,
                      color: Colors.teal.shade900
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
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.red.shade900,
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
              ? Colors.teal.shade900
              : Colors.teal.shade900,
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
                color: Colors.teal.shade900,
              ),
              Container(
                color: Colors.teal.shade900,
              ),
              Container(
                color: Colors.teal.shade900,
              ),
              Container(
                color: Colors.teal.shade900,
              ),
              Container(
                color: Colors.teal.shade900,
              ),
              Container(
                color: Colors.teal.shade900,
              )
            ],
          )
        ),
      ),
    );
  }
}