
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/category_model.dart';
import 'package:gaindesat_ddp_client/models/full_user.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/models/user.dart';
import 'package:gaindesat_ddp_client/services/admin/category_services.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/user/user_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import '../../../services/admin/user_services.dart';
import '../../../services/helper.dart';

class UserScreen extends StatefulWidget {

  const UserScreen({super.key});

  @override
  State createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _keys = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  late final Future<List<FullUser>> futureUsers;
  late final Future<List<ReduceCategory>> futureCategories;
  late final Future<List<ReducePartner>> futurePartners;

  ReducePartner? partnerValue;
  ReduceCategory? categoryValue;

  String? username, email, password, fullName, deleteUserUUID, categoryUUID, partnerUUID;

  bool status = false;
  bool _showForm = false;
  bool _obscureText = true;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  void initState() {
    super.initState();
    futureUsers = UserService().fetchUsers();
    futurePartners = PartnerService().fetchPartners();
    futureCategories = CategoryService().fetchCategories();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Users Management',
                  style: TextStyle(
                      color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            backgroundColor: Colors.teal,
            centerTitle: true,
            iconTheme: IconThemeData(
                color: isDarkMode(context)
                    ? Colors.tealAccent
                    : Colors.tealAccent
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<UserBloc, UserManagementState>(
                  listener: (context, state) async {
                    await context.read<LoadingCubit>().hideLoading();
                    if ((state.userState == UserState.addSuccess)
                    || (state.userState == UserState.deleteSuccess)
                    || (state.userState == UserState.updateSuccess)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const UserScreen()));
                      showSnackBarSuccess(context, state.message!);
                    } else if ((state.userState == UserState.addError)
                    || (state.userState == UserState.deleteError)
                    || (state.userState == UserState.updateError)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const UserScreen()));
                    }
                  }
              ),
              BlocListener<UserBloc, UserManagementState>(
                listener: (context, state) async {
                  if (state.userState == UserState.deleteInit) {
                    await context.read<LoadingCubit>().showLoading(context, "Deleting user", false);
                    if(!mounted) return;
                    context.read<UserBloc>().add(
                      UserDeleteEvent(fullUserUUID: deleteUserUUID!)
                    );
                  }
                },
              ),
              BlocListener<UserBloc, UserManagementState>(
                  listener: (context, state) async {
                    if (state.userState == UserState.validUserFields) {
                      await context.read<LoadingCubit>().showLoading(context, "Adding a new User !! Please wait", false);
                      if (!mounted) return;
                      context.read<UserBloc>().add(
                        UserAddEvent(user: User(
                            username: username!,
                            email: email!,
                            password: password!,
                            fullName: fullName!,
                            status: status,
                            categoryUUID: categoryValue?.uuid ?? "",
                            partnerUUID: partnerValue?.uuid ?? ""
                        ))
                    );
                  }
                }
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 1,
                              right: 29
                          ),
                          child: FloatingActionButton.extended(
                            heroTag: 'addUser',
                            backgroundColor: Colors.teal,
                            tooltip: 'Add user',
                            elevation: 10,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.tealAccent,
                            ),
                            onPressed: _toggleFormShown,
                            label: const Text(
                              'Add User',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12
                      ),
                      child: FutureBuilder<List<FullUser>>(
                    future: futureUsers,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: Colors.teal,
                                shadowColor: Colors.tealAccent,
                                elevation: 10,
                                child: Container(
                                  height: MediaQuery.of(context).size.height /2.5,
                                  width: MediaQuery.of(context).size.width /2.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:  [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              top: 0,
                                              right: 15,
                                            ),
                                            child: CircleAvatar(
                                              radius: 65,
                                              backgroundImage: AssetImage('assets/images/placeholder.jpg'),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: ListTile(
                                                title: Text(
                                                    snapshot.data![index].fullName,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 21)
                                                ),
                                                subtitle: Text(
                                                    snapshot.data![index].username,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 19)
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child:Chip(
                                                label: (snapshot.data![index].status == true)
                                                    ? const Text(
                                                  "Active",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                )
                                                    : const Text(
                                                    "Inactive",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                                backgroundColor: (snapshot.data![index].status == true)
                                                    ? Colors.teal[800]
                                                    : Colors.red,
                                                elevation: 10,
                                              )
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 130,
                                            left: 0
                                        ),
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.tealAccent,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 150,
                                            left: 20
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 0,
                                                        right: 17
                                                    ),
                                                    child: Icon(
                                                      Icons.email,
                                                      size: 32,
                                                      color: Colors.tealAccent,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        snapshot.data![index].email,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 21)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 0,
                                                        right: 17
                                                    ),
                                                    child: Icon(
                                                      Icons.public_outlined,
                                                      size: 32,
                                                      color: Colors.tealAccent,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        snapshot.data![index].partnerName!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 21)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 0,
                                                        right: 17
                                                    ),
                                                    child: Icon(
                                                      Icons.category_rounded,
                                                      size: 32,
                                                      color: Colors.tealAccent,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        snapshot.data![index].categoryName!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 21)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 0,
                                                        right: 17
                                                    ),
                                                    child: Icon(
                                                      Icons.shield,
                                                      color: Colors.tealAccent,
                                                      size: 32,
                                                    ),
                                                  ),
                                                  for(int i = 0; i < snapshot.data![index].roles!.length; i++) ...[
                                                    Expanded(
                                                        flex: 1,
                                                        child:Chip(
                                                          label: Text(
                                                            snapshot.data![index].roles![i],
                                                            style: const TextStyle(
                                                                color: Colors.grey
                                                            ),
                                                          ),
                                                          backgroundColor: Colors.tealAccent,
                                                          elevation: 10,
                                                        )
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 27,
                                                  left: 20,
                                                  right: 20
                                              ),
                                              child: Row(
                                                children:  [
                                                  Expanded(
                                                    child: FloatingActionButton.extended(
                                                      heroTag: null,
                                                      backgroundColor: Colors.teal,
                                                      tooltip: 'Update',
                                                      elevation: 10,
                                                      icon: const Icon(
                                                        Icons.update,
                                                        color: Colors.tealAccent,
                                                      ),
                                                      onPressed: () => {},
                                                      label: const Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 80
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FloatingActionButton.extended(
                                                      heroTag: null,
                                                      backgroundColor: Colors.red.shade900,
                                                      tooltip: 'Delete',
                                                      elevation: 10,
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.tealAccent,
                                                      ),
                                                      onPressed: () => {
                                                        deleteUserUUID = snapshot.data![index].uuid,
                                                        showAlertDialog(context)
                                                      },
                                                      label: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 650,
                              childAspectRatio: 1,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                            ),
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    ),
                    BlocBuilder<UserBloc, UserManagementState>(
                      buildWhen: (old, current) =>
                      current.userState is UserManagementState && old != current,
                      builder: (context, state) {
                        if (state.userState == UserState.failureFillUserFields) {
                          _validate = AutovalidateMode.onUserInteraction;
                        }
                        return Card(
                          elevation: 12,
                          color: Colors.teal,
                          child: _showForm ?
                          SizedBox(
                            width: MediaQuery.of(context).size.width /2.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 46
                              ),
                              child: Form(
                                key: _key,
                                autovalidateMode: _validate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 50.0,
                                          right: 16.0,
                                          left: 16.0
                                      ),
                                      child: Text(
                                        'Create new User',
                                        style: TextStyle(
                                            color: Colors.white,//Color.fromRGBO(0, 132, 121, 100),
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14,
                                          right: 24.0,
                                          left: 24.0
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateUsername,
                                        onSaved: (String? val) {
                                          fullName = val;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.perm_identity_outlined,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: "FullName",
                                            hintStyle: const TextStyle(
                                                color: Colors.white
                                            ),
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 27.0,
                                          right: 24.0,
                                          left: 24.0
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: null,
                                        onSaved: (String? val) {
                                          username = val;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.tealAccent,
                                              size: 24,
                                            ),
                                            hint: 'Username',
                                            hintStyle: const TextStyle(
                                                color: Colors.white
                                            ),
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 27,
                                          right: 24.0,
                                          left: 24.0
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: null,
                                        onSaved: (String? val) {
                                          email = val;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.email,
                                              color: Colors.tealAccent,
                                              size: 24,
                                            ),
                                            hint: "Email",
                                            hintStyle: const TextStyle(
                                                color: Colors.white
                                            ),
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 27,
                                          right: 24.0,
                                          left: 24.0,
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
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.tealAccent,
                                            size: 24,
                                          ),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                            child: GestureDetector(
                                              onTap: _toggle,
                                              child: Icon(
                                                  color: Colors.tealAccent,
                                                  _obscureText
                                                      ? Icons.visibility_rounded
                                                      : Icons.visibility_off_rounded,
                                                  size: 24
                                              ),
                                            ),
                                          ),
                                          hint: 'Password',
                                          hintStyle: const TextStyle(
                                              color: Colors.white
                                          ),
                                          darkMode: isDarkMode(context),
                                          errorColor: Theme.of(context).colorScheme.error,
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 27,
                                          right: 24.0,
                                          left: 24.0
                                      ),
                                      child: Row(

                                        children: [
                                          const Text(
                                            'Status',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white
                                            ),
                                          ),
                                          Switch(
                                            thumbIcon: thumbIcon,
                                            activeColor: Colors.tealAccent,
                                            inactiveThumbColor: Colors.red,
                                            inactiveTrackColor: Colors.teal,
                                            value: status,
                                            onChanged: (bool value) {
                                              setState(() {
                                                status = value;
                                              });
                                            },
                                          ),

                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                  right: 24.0,
                                                  left: 24.0
                                              ),
                                              child: FutureBuilder<List<ReducePartner>>(
                                                  future: futurePartners,
                                                  builder: (context, snapshot) {
                                                    if(snapshot.hasData) {
                                                      return SizedBox(
                                                        width: 200,
                                                        child:  DropdownButtonFormField(
                                                          key: _keys,
                                                          dropdownColor: Colors.teal,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.white
                                                          ),
                                                          decoration: getInputDecoration(
                                                            hint: 'Choose PartnerShip',
                                                            hintStyle: const TextStyle(
                                                                color: Colors.white
                                                            ),
                                                            darkMode: isDarkMode(context),
                                                            errorColor: Theme.of(context).colorScheme.error,
                                                          ),
                                                          isExpanded: true,
                                                          value: partnerValue,
                                                          onChanged: (ReducePartner? partner) {
                                                            setState(() {
                                                              partnerValue = partner!;
                                                            });
                                                          },
                                                          items: snapshot.data?.map<DropdownMenuItem<ReducePartner>>((ReducePartner partner) {
                                                            return
                                                              DropdownMenuItem<ReducePartner>(
                                                                value: partner,
                                                                child: Text(
                                                                  partner.name!,
                                                                  style: const TextStyle(fontSize: 14),
                                                                ),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      );
                                                    } else {
                                                      return const Text('');
                                                    }
                                                  }
                                              )
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                  right: 24.0,
                                                  left: 24.0
                                              ),
                                              child: FutureBuilder<List<ReduceCategory>>(
                                                  future: futureCategories,
                                                  builder: (context, snapshot) {
                                                    if(snapshot.hasData) {
                                                      return SizedBox(
                                                        width: 180,
                                                        child:  DropdownButtonFormField(
                                                          dropdownColor: Colors.teal,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.white
                                                          ),
                                                          decoration: getInputDecoration(
                                                            hint: 'Choose Category',
                                                            hintStyle: const TextStyle(
                                                                color: Colors.white
                                                            ),
                                                            darkMode: isDarkMode(context),
                                                            errorColor: Theme.of(context).colorScheme.error,
                                                          ),
                                                          isExpanded: true,
                                                          value: categoryValue,
                                                          onChanged: (ReduceCategory? category) {
                                                            setState(() {
                                                              categoryValue = category!;
                                                            });
                                                          },
                                                          items: snapshot.data?.map<DropdownMenuItem<ReduceCategory>>((ReduceCategory category) {
                                                            return
                                                              DropdownMenuItem<ReduceCategory>(
                                                                value: category,
                                                                child: Text(
                                                                  category.catName,
                                                                  style: const TextStyle(fontSize: 14),
                                                                ),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      );
                                                    } else {
                                                      return const Text('');
                                                    }
                                                  }
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 27,
                                              right: 23,
                                              left: 0,
                                              bottom: 0
                                          ),
                                          child: FloatingActionButton.extended(
                                              heroTag: null,
                                              backgroundColor: Colors.teal,
                                              tooltip: 'Submit',
                                              elevation: 10,
                                              icon: const Icon(
                                                Icons.create,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () => context
                                              .read<UserBloc>()
                                              .add(ValidateUserFieldsEvent(_key)),
                                              label: const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0,
                                                right: 0,
                                                left: 23,
                                                bottom: 0
                                            ),
                                          child: FloatingActionButton.extended(
                                              heroTag: null,
                                              backgroundColor: Colors.red.shade900,
                                              tooltip: "Cancel",
                                              elevation: 10,
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed:() {
                                                _key.currentState?.reset();
                                                _keys.currentState?.reset(); // don't work yet
                                               _toggleFormShown();
                                              },
                                              label: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ): const Text(''),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget deleteButton = FloatingActionButton.extended(
      onPressed: () => { context.read<UserBloc>().add(UserDeleteInitEvent()),
        Navigator.of(context).pop()
      },
      icon: const Icon(
      Icons.done_all_outlined,
      color: Colors.tealAccent,
    ),
      label: const Text(
        'Delete',
        style: TextStyle(
            color: Colors.tealAccent
        ),
      ),
    backgroundColor: Colors.teal,
  );

  Widget cancelButton = FloatingActionButton.extended(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.clear,
        color: Colors.tealAccent,
      ),
    label: const Text(
      'Cancel',
      style: TextStyle(
          color: Colors.tealAccent
      ),
    ),
    backgroundColor: Colors.red.shade900,
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.teal,
    alignment: Alignment.center,
    title: const Text('Confirmation Dialog'),
    titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 23
    ),
    content: const Text(
      "Delete User ?",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w300
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      deleteButton,
      cancelButton
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
  );
}