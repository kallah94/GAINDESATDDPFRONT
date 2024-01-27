
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/login/login_screen.dart';
import 'package:gaindesat_ddp_client/ui/auth/welcome/welcome_bloc.dart';

import '../../../services/helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WelcomeBloc>(
      create: (context) => WelcomeBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocListener<WelcomeBloc, WelcomeInitial>(
              listener: (context, state) {
                switch (state.pressTarget) {
                  case WelcomePressTarget.login:
                    push(context, const LoginScreen());
                    break;
                  default:
                    break;
                }
              },
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.only(
                        top: 40,
                      )
                  ),
                  Center(
                    child: Image.asset(
                        'assets/images/logo.png',
                      width: 450.0,
                      height: 350.0,
                      fit: BoxFit.fill
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 40,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'G.A.I.N.D.E.S.A.T',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 37
                    ),
                  ),
                  Center(
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Gestion Automatique d\'Informations et de Données Environnementales par Satellite',
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w100,
                          ),
                          curve: Curves.easeIn,
                          speed: const Duration(milliseconds: 200)
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(
                        top: 77
                      ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(
                          MediaQuery.of(context).size.width / 5.5
                        ),
                        backgroundColor: const Color.fromRGBO(0, 132, 121, 100),
                        textStyle: const TextStyle(color: Colors.blue),
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const  BorderSide(color: Colors.white)
                        ),

                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      onPressed: () {
                        context.read<WelcomeBloc>().add(LoginPressed());
                      },
                    ),
                  ),
                   const Padding(
                     padding: EdgeInsets.only(
                       top: 200,
                       left: 0,
                       right: 0,
                       bottom: 0
                     ),
                   ),
                   Center(
                   child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50,
                              top: 50,
                              right: 10,
                              bottom: 0
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/mesri.jpeg',
                              width: 150.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50,
                              top: 50,
                              right: 10,
                              bottom: 0
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/DGPRE.png',
                              width: 150.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50,
                              top: 50,
                              right: 10,
                              bottom: 0
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/olac.png',
                              width: 150.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50,
                              top: 50,
                              right: 10,
                              bottom: 0
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/OFOR.png',
                              width: 200.0,
                              height: 225.0,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50,
                              top: 50,
                              right: 10,
                              bottom: 0
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              'assets/images/csum.jpg',
                              width: 150.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}