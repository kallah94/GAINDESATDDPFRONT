
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/welcome/welcome_screen.dart';
import 'package:gaindesat_ddp_client/ui/home.dart';

import '../onBoarding/data.dart';
import '../onBoarding/on_boarding_screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  void initStat() {
    super.initState();
    context.read<AuthenticationBloc>().add(CheckFirstRunEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.authState) {
            case AuthState.firstRun:
              pushReplacement(
                  context,
                  OnBoardingScreen(
                    images: imageList,
                    titles: titlesList,
                    subtitles: subtitlesList,
                  ));
              break;
            case AuthState.authenticated:
              pushReplacement(context, HomeScreen(userDetails: state.userDetails!));
              break;
            case AuthState.unauthenticated:
              pushReplacement(context, const WelcomeScreen());
              break;
            default:
              pushReplacement(context, const WelcomeScreen());
          }
        },
        child: const WelcomeScreen()
      ),
    );
  }
}