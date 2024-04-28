import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/services/helper.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import 'package:gaindesat_ddp_client/ui/profile/profile_bloc.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              ],
            ),
            backgroundColor: Colors.teal,
            iconTheme: const IconThemeData(
              color: Colors.tealAccent
            ),
          ),
          body: MultiBlocListener(
            listeners: <BlocListener>[
              BlocListener<ProfileBloc, ProfileManagementState>(
                listener: (context, state) async {
                  await context.read<LoadingCubit>().hideLoading();
                  if (state.profileState == ProfileState.editProfileDataSuccess) {
                    if (!mounted) return;
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ProfileScreen()));
                    showSnackBarSuccess(context, state.message!);
                  } else {
                    if (state.profileState == ProfileState.editProfileDataError) {
                      if(!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()));
                      showSnackBar(context, state.message!);
                    }
                  }
                },
              )
            ],
            child: Container(
              color: Colors.white54,
              child:  Column(
                children: [
                  const SizedBox(height: 15),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Stack(
                        children: [
                        const Material(
                        shadowColor: Colors.teal,
                        shape: CircleBorder(side:BorderSide.none),
                        elevation: 17,
                        child: CircleAvatar(
                          radius: 143,
                          foregroundColor: Colors.tealAccent,
                          backgroundColor: Colors.deepOrangeAccent,
                          backgroundImage: AssetImage(
                      "assets/images/moussa.jpeg"
                        ),
                        ),
                        ),
                       Positioned(
                        bottom: 13,
                        right: 43,
                        child: IconButton(
                          style: IconButton.styleFrom(backgroundColor: Colors.teal),
                          hoverColor: Colors.teal,
                          onPressed: () {  },
                          icon: const Icon(Icons.camera_alt, color: Colors.tealAccent),
                        )
                      ),
                      ],
                    ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/LinkedIn.png"),
                      ),
                      SizedBox(width: 15),
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/facebook.png"),
                      ),
                      SizedBox(width: 15),
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/twitter.png"),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 292,
                        child: ListTile(
                         title: Text("Moussa FALL",
                           textAlign: TextAlign.center,
                           style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                        ),
                          trailing: Icon(Icons.circle, color: Colors.greenAccent),
                      )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Expanded(
                      child: ListView(
                        children: [
                          Card(
                            elevation: 6,
                            margin: const EdgeInsets.only(left: 85, right: 85, bottom: 10),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: const ListTile(
                              leading: Icon(Icons.group, color: Colors.teal),
                              title: Text(
                                "Nom de la Structure",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.teal),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Card(
                                    color: Colors.white70,
                                    elevation: 12,
                                    margin: const EdgeInsets.only(left: 85, right: 13, bottom: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const ListTile(
                                      leading: Icon(
                                          Icons.verified_user,
                                          color: Colors.teal,
                                      ),
                                      title: Text(
                                        'Username',
                                      textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Expanded(
                                  child: Card(
                                    color: Colors.white70,
                                    elevation: 12,
                                    margin: const EdgeInsets.only(left: 13, right: 85, bottom: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const ListTile(
                                      leading: Icon(
                                        Icons.email,
                                        color: Colors.teal,
                                      ),
                                      title: Text(
                                        'Email',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.white70,
                                  elevation: 12,
                                  margin:
                                  const EdgeInsets.only(left: 85, right: 13, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const ListTile(
                                      leading: Icon(
                                        Icons.history,
                                        color: Colors.teal,
                                      ),
                                      title: Text(
                                        "Catégory d'utilisateur",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                ) ,
                              ),
                              Expanded(
                                child: Card(
                                  color: Colors.white70,
                                  elevation: 12,
                                  margin:
                                  const EdgeInsets.only(left: 13, right: 85, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const ListTile(
                                      leading: Icon(
                                        Icons.settings,
                                        color: Colors.teal,
                                      ),
                                      title: Text(
                                        "Rôle",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                ) ,
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex:2,
                               // width: 370,
                                child: Card(
                                  elevation: 18,
                                  color: Colors.white70,
                                  margin:  const EdgeInsets.only(left: 85, right: 10, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const ListTile(
                                    leading: Icon(
                                      Icons.privacy_tip,
                                      color: Colors.teal,
                                    ),
                                    title: Text(
                                      'Droits accordées',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                //width: 180,
                                child: Card(
                                  elevation: 18,
                                  color: Colors.lightGreenAccent,
                                  margin:  EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(43, 63),
                                          bottomRight: Radius.elliptical(63, 43)
                                      )
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: Colors.teal,
                                    ),
                                    title: Text(
                                      'Éditer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                //width: 180,
                                child: Card(
                                  elevation: 18,
                                  color: Colors.orange,
                                  margin:  EdgeInsets.only(left: 0, right: 0, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(43, 63),
                                  bottomRight: Radius.elliptical(63, 43)
                                    )
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Colors.teal,
                                    ),
                                    title: Text(
                                      'Lire',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                               // width: 180,
                                child: Card(
                                  elevation: 18,
                                  color: Color.fromARGB(255, 200, 225, 0),
                                  margin:  EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(43, 63),
                                          bottomRight: Radius.elliptical(63, 43)
                                      )
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.file_download_rounded,
                                      color: Colors.teal,
                                    ),
                                    title: Text(
                                      'Exporter',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                               // width: 180,
                                child: Card(
                                  elevation: 18,
                                  color: Colors.red,
                                  margin:  EdgeInsets.only(right: 85 ,bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(43, 63),
                                          bottomRight: Radius.elliptical(63, 43)
                                      )
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.remove_circle,
                                      color: Colors.teal,
                                    ),
                                    title: Text(
                                      'Supprimer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                child: FloatingActionButton.extended(
                                  onPressed: () {},
                                  elevation: 12,
                                  heroTag: 'update-profil',
                                  backgroundColor: Colors.teal,
                                  label: const Text("Update profile"),
                                  icon: const Icon(Icons.update),
                                ),
                              ),
                              BlocBuilder<ProfileBloc, ProfileManagementState>(
                                buildWhen: (old, current) =>
                                current.profileState is ProfileManagementState && old != current,
                                builder: (context, state) {
                                  if (state.profileState == ProfileState.failureFillProfileState) {
                                    _validate = AutovalidateMode.onUserInteraction;
                                  }
                                  return const Card(
                                    // Form for user informations updated
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
        );
      }),
    );
  }
}