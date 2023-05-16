import 'package:flutter/material.dart';
import 'package:gaindesat_ddp_client/ui/admin/admin_home_screen.dart';
import 'package:gaindesat_ddp_client/ui/auth/authentication_bloc.dart';
import 'package:gaindesat_ddp_client/ui/auth/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/helper.dart';
import '../../home.dart';
import '../../loading_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}): super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? username, password;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: Colors.black),
          elevation: 0.0,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) async {
                  await context.read<LoadingCubit>().hideLoading();
                  if (state.authState == AuthState.authenticated) {
                    if (!mounted) return;
                    pushAndRemoveUntil(
                      context, HomeScreen(userDetails: state.userDetails!),
                        false
                    );
                  } else if (state.authState == AuthState.isAdmin) {
                    if (!mounted) return;
                    pushAndRemoveUntil(
                        context, AdminHomeScreen(userDetails: state.userDetails!),
                        false
                    );
                  } else {
                    if (!mounted) return;
                    showSnackBar(context, state.message ?? 'Couldn\' login, Please try again');
                  }
                },
              ),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) async {
                  if (state is ValidLoginFields) {
                    await context.read<LoadingCubit>().showLoading(
                        context, 'Logging in, Please wait...', false);
                    if (!mounted) return;
                    context.read<AuthenticationBloc>().add(
                      LoginWithUsernameAndPasswordEvent(
                          username: username!,
                          password: password!
                      ),
                    );
                  }
                },
              )
            ],
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (old, current) =>
              current is LoginFailureState && old != current,
              builder: (context, state) {
                if (state is LoginFailureState) {
                  _validate = AutovalidateMode.onUserInteraction;
                }
                return Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                              'assets/images/logo.png',
                              width: 450.0,
                              height: 350.0,
                              fit: BoxFit.fill
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 46
                          ),
                          child: Text(
                            'PLATEFORME DE DIFFUSION DE DONNEES',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 26
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 50.0,
                              right: 16.0,
                              left: 16.0
                            ),
                            child: Text(
                              'Connexion',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 132, 121, 100),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 32.0,
                            right: 24.0,
                            left: 24.0
                          ),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            validator: validateUsername,
                            onSaved: (String? val) {
                              username = val;
                            },
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.name,
                            cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                            decoration: getInputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromRGBO(0, 132, 121, 100),
                                size: 24,
                              ),
                              hint: 'Username',
                              darkMode: isDarkMode(context),
                              errorColor: Theme.of(context).colorScheme.error
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 32.0,
                            right: 24.0,
                            left: 24.0
                          ),
                          child: TextFormField(
                            obscuringCharacter: '*',
                            keyboardType: TextInputType.visiblePassword,
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: _obscureText,
                            validator: validatePassword,
                            onSaved: (String? val) {
                              password = val;
                            },
                            onFieldSubmitted: (password) => context
                              .read<LoginBloc>()
                              .add(ValidateLoginFieldsEvent(_key)),
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              fontSize: 18.0),
                            cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                            decoration: getInputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromRGBO(0, 132, 121, 100),
                                size: 24,
                              ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggle,
                                    child: Icon(
                                        color: const Color.fromRGBO(0, 132, 121, 100),
                                        _obscureText
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                          size: 24
                                    ),
                                  ),
                                ),
                                hint: 'Password',
                                darkMode: isDarkMode(context),
                                errorColor: Theme.of(context).colorScheme.error)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 40.0,
                            left: 40.0,
                            top: 40
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(
                                MediaQuery.of(context).size.width / 4.5
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 19),
                              backgroundColor: const Color.fromRGBO(0, 132, 121, 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23.0),
                                side: const BorderSide(
                                  color: Color.fromRGBO(0, 132, 121, 100),
                                )
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () => context
                                .read<LoginBloc>()
                                .add(ValidateLoginFieldsEvent(_key)),
                          ),
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),
          );
      })
    );
  }
}