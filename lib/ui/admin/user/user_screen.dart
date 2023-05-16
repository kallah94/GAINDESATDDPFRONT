import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaindesat_ddp_client/models/full_user.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';
import '../../../services/admin/user_services.dart';
import '../../../services/helper.dart';

class UserScreen extends StatefulWidget {

  const UserScreen({super.key});

  @override
  State createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final AutovalidateMode _validate = AutovalidateMode.disabled;
  late Future<List<FullUser>> futureUsers;
  late Future<List<ReducePartner>> test;
  String? username, email, password, confirmPassword, fullName;
  bool _showForm = false;
  bool _obscureText = true;

  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
    });
  }
  @override
  void initState() {
    super.initState();
    futureUsers = UserService().fetchUsers();
    test = PartnerService().fetchPartners();
  }
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Users Management',
                style: TextStyle(
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          backgroundColor: const Color.fromRGBO(0, 132, 121, 100),
          centerTitle: true,
          iconTheme: IconThemeData(
              color: isDarkMode(context)
                  ? Colors.grey.shade50
                  : Colors.grey.shade50
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
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
                            backgroundColor: const Color.fromRGBO(0, 132, 121, 100),
                            tooltip: 'Add user',
                            elevation: 10,
                            icon: const Icon(Icons.add),
                            onPressed: _toggleFormShown,
                            label: const Text('Add User'),
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
                              shadowColor: Colors.orangeAccent,
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
                                              ? const Text("Active")
                                              : const Text("Inactive"),
                                              backgroundColor: (snapshot.data![index].status == true)
                                              ? Colors.greenAccent
                                              : Colors.redAccent,
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
                                        color: Colors.greenAccent,
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
                                                    color: Colors.greenAccent,
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
                                                    color: Colors.greenAccent,
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
                                                    color: Colors.greenAccent,
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
                                                    color: Colors.greenAccent,
                                                    size: 32,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child:Chip(
                                                      label: Text(snapshot.data![index].roles![0]),
                                                      backgroundColor: Colors.greenAccent,
                                                      elevation: 10,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child:Chip(
                                                      label: Text(snapshot.data![index].roles![1]),
                                                      backgroundColor: Colors.lightGreenAccent,
                                                      elevation: 10,
                                                    )
                                                ),
                                                const Expanded(
                                                    flex: 1,
                                                    child:Chip(
                                                      label: Text('DELETE'),
                                                      backgroundColor: Colors.redAccent,
                                                      elevation: 10,
                                                    )
                                                ),
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
                                                    backgroundColor: Colors.greenAccent,
                                                    tooltip: 'Update',
                                                    elevation: 10,
                                                    icon: const Icon(
                                                      Icons.update,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () => {},
                                                    label: const Text(
                                                      'Update',
                                                      style: TextStyle(
                                                          color: Colors.black
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
                                                    backgroundColor: Colors.redAccent,
                                                    tooltip: 'Delete',
                                                    elevation: 10,
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () => {},
                                                    label: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.black
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
                            maxCrossAxisExtent: 500,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ) ,
                ),
                Card(
                  elevation: 12,
                  color: Colors.grey.shade100,
                  shadowColor: Colors.greenAccent,
                  child: _showForm ?
                      SizedBox(
                        width: MediaQuery.of(context).size.width /2.5,
                        child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 46
                    ),
                      child: Form(
                        key: _key,
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
                                    color: Color.fromRGBO(0, 132, 121, 100),
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
                                style: const TextStyle(fontSize: 18.0),
                                keyboardType: TextInputType.name,
                                cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                                decoration: getInputDecoration(
                                    hint: "FullName",
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
                                validator: validateUsername,
                                onSaved: (String? val) {
                                  username = val;
                                },
                                style: const TextStyle(
                                    fontSize: 18.0,
                                ),
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
                                  top: 27,
                                  right: 24.0,
                                  left: 24.0
                              ),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                validator: validateUsername,
                                onSaved: (String? val) {
                                  email = val;
                                },
                                style: const TextStyle(fontSize: 18.0),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                                decoration: getInputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Color.fromRGBO(0, 132, 121, 100),
                                    size: 24,
                                  ),
                                    hint: "Email",
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
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.visiblePassword,
                                  textAlignVertical: TextAlignVertical.center,
                                  obscureText: _obscureText,
                                  validator: validatePassword,
                                  onSaved: (String? val) {
                                    password = val;
                                  },
                                  textInputAction: TextInputAction.next ,
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
                                  top: 27,
                                  right: 24.0,
                                  left: 24.0
                              ),
                              child: TextFormField(
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.visiblePassword,
                                  textAlignVertical: TextAlignVertical.center,
                                  obscureText: true,
                                  validator: validatePassword,
                                  onSaved: (String? val) {
                                    confirmPassword = val;
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                      fontSize: 18.0),
                                  cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                                  decoration: getInputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Color.fromRGBO(0, 132, 121, 100),
                                        size: 24,
                                      ),
                                      hint: 'Confirm Password',
                                      darkMode: isDarkMode(context),
                                      errorColor: Theme.of(context).colorScheme.error)
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
                                    tooltip: 'Delete',
                                    elevation: 10,
                                    icon: const Icon(
                                      Icons.create,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () => {},
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
                                    backgroundColor: Colors.red,
                                    tooltip: 'Cancel',
                                    elevation: 10,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.orangeAccent,
                                    ),
                                    onPressed: () => {},
                                    label: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      )))
                      : const Text('')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}