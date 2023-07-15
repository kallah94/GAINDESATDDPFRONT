import 'package:flutter/material.dart';
import 'package:gaindesat_ddp_client/services/admin/permission_services.dart';

import '../../../models/permission.dart';
import '../../../services/helper.dart';

class PermissionScreen extends StatefulWidget {

  const PermissionScreen({super.key});

  @override
  State createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {

  final GlobalKey<FormState> _key = GlobalKey();
  bool _showForm = false;

  late final Future<List<Permission>> futurePermissions;
  String? code, title;
  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePermissions = PermissionService().fetchPermissions();
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
              'Permissions Management',
              style: TextStyle(
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(
          color: isDarkMode(context)
              ? Colors.tealAccent
              : Colors.tealAccent
        ),
      ),
      body: Padding(
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
                      heroTag: 'AddPermission',
                      backgroundColor: Colors.teal,
                      tooltip: 'Add New Permission',
                      elevation: 10,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.tealAccent,
                      ),
                      onPressed: _toggleFormShown,
                      label: const Text(
                        'Add Permission',
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
                child: FutureBuilder<List<Permission>>(
                  future: futurePermissions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Colors.teal,
                            semanticContainer: true,
                            shadowColor: Colors.tealAccent,
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 27,
                                  left: 0
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        left: 0,
                                        right: 17
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              top: 0,
                                              left: 17,
                                              right: 17
                                            ),
                                            child: Icon(
                                              Icons.security_outlined,
                                              size: 32,
                                              color: Colors.tealAccent,
                                            ),
                                          ),
                                           Expanded(
                                             flex: 1,
                                            child: Text(
                                                'Code: ${snapshot.data![index].code}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 21,
                                                )
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                'Title: ${snapshot.data![index].title}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 21,
                                                )
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: Colors.teal,
                                              mini: false,
                                              child: const Icon(
                                                Icons.update,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () {  },

                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: Colors.red.shade900,
                                              mini: false,
                                              child: const Icon(
                                                  Icons.delete,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () {  },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          childAspectRatio: 4/2,
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
              Card(
                elevation: 12,
                color: Colors.teal,
                child: _showForm
                ? SizedBox(
                  width: MediaQuery.of(context).size.width /2.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 40
                    ),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 0,
                              left: 0,
                              right: 0
                            ),
                            child: Text(
                              'Create new Permission',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 34,
                              right: 24,
                              left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: null,
                              onSaved: (String? val) {
                                code = val;
                              },
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.tealAccent,
                              decoration: getInputDecoration(
                                  hint: 'Code',
                                  hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 23
                                  ),
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 34,
                                right: 24,
                                left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              validator: null,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.tealAccent,
                              decoration: getInputDecoration(
                                  hint: 'Title',
                                  hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 23
                                  ),
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).colorScheme.error,
                              ),
                              onSaved: (String? val) {
                                title = val;
                              },
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
                                  backgroundColor: Colors.red.shade900,
                                  tooltip: 'Cancel',
                                  elevation: 10,
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.tealAccent,
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
                          )
                        ],
                      ),
                    ),
                  ),
                )
                : Container(),
              )
            ],
          )
        )
      ),
    );
  }

}