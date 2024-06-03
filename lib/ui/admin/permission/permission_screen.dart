import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/services/admin/category_services.dart';
import 'package:gaindesat_ddp_client/services/admin/permission_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/permission/permission_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

import '../../../models/category_model.dart';
import '../../../models/permission.dart';
import '../../../services/helper.dart';

class PermissionScreen extends StatefulWidget {

  const PermissionScreen({super.key});

  @override
  State createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  String? code, title, deletePermissionUUID, categoryUUID;
  bool _showForm = false;
  late final Future<List<Permission>> futurePermissions;
  late final Future<List<ReduceCategory>> futureCategoryModels;
  ReduceCategory? categoryValue;

  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePermissions = PermissionService().fetchPermissions();
    futureCategoryModels = CategoryService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PermissionBloc>(
      create: (context) => PermissionBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar:  AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Permissions Management',
                  style: TextStyle(
                      color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            backgroundColor: Colors.teal.shade900,
            iconTheme: IconThemeData(
                color: isDarkMode(context)
                    ? Colors.tealAccent
                    : Colors.tealAccent
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<PermissionBloc, PermissionManagementState>(
                  listener: (context, state) async {
                    await context.read<LoadingCubit>().hideLoading();
                    if ((state.permissionState == PermissionState.addSuccess)
                        || (state.permissionState == PermissionState.deleteSuccess)
                    || (state.permissionState == PermissionState.updateSuccess)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const PermissionScreen()));
                      showSnackBarSuccess(context, state.message!);
                    } else if ((state.permissionState == PermissionState.addError)
                        || (state.permissionState == PermissionState.deleteError)
                    || (state.permissionState == PermissionState.updateError)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const PermissionScreen()));
                      showSnackBar(context, state.message!);
                    }
                  }
              ),
              BlocListener<PermissionBloc, PermissionManagementState>(
                listener: (context, state) async {
                  if (state.permissionState == PermissionState.deleteInit) {
                    await context.read<LoadingCubit>().showLoading(context, "Deleting Permission", false);
                    if (!mounted) return;
                    context.read<PermissionBloc>().add(
                      PermissionDeleteEvent(permissionUUID: deletePermissionUUID!)
                    );
                  }
                },
              ),
              BlocListener<PermissionBloc, PermissionManagementState>(
                listener: (context, state) async {
                  if (state.permissionState == PermissionState.validPermissionFields) {
                    await context.read<LoadingCubit>().showLoading(context, "Adding a Permission !! Please wait", false);
                    if (!mounted) return;
                    context.read<PermissionBloc>().add(
                      PermissionAddEvent(permission: Permission(code: code!, title: title!, categoryUUID: categoryValue?.uuid ?? "")));
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
                            left: 0,
                            right: 0,
                          ),
                          child: FloatingActionButton.extended(
                            heroTag: 'AddPermission',
                            backgroundColor: Colors.teal.shade900,
                            tooltip: 'Add new Permission',
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
                      child: FutureBuilder<List<Permission>> (
                        future: futurePermissions,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  color: Colors.teal.shade900,
                                  semanticContainer: true,
                                  shadowColor: Colors.tealAccent,
                                  elevation: 10,
                                  child: Container(
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
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                top: 0,
                                                right: 0,
                                                left: 0
                                              ),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: AssetImage('assets/images/welcome_image.png'),
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
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Title: ${snapshot.data![index].title}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 21
                                                ),
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
                                                onPressed: () {},
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
                                                onPressed: () => {
                                                  deletePermissionUUID = snapshot.data![index].uuid,
                                                  showAlertDialog(context)
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 600,
                                childAspectRatio: 3/1,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1
                              ),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator()
                            );
                          }
                        },
                      ),
                    ),
                    BlocBuilder<PermissionBloc, PermissionManagementState>(
                      buildWhen: (old, current) =>
                      current.permissionState is PermissionManagementState && old != current,
                      builder: (context, state) {
                        if (state.permissionState == PermissionState.failureFillPermissionFields) {
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
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        bottom: 0
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
                                      padding:  const EdgeInsets.only(
                                          top: 34,
                                          right: 24,
                                          left: 24
                                        ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          code = val!;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key_rounded,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: "Code of the Permission",
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
                                          right: 24,
                                          left: 24
                                      ),
                                      child: FutureBuilder<List<ReduceCategory>>(
                                        future: futureCategoryModels,
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData) {
                                            return SizedBox(
                                              width: 200,
                                              child: DropdownButtonFormField(
                                                validator: (value) => value == null ? 'field required' : null,
                                                dropdownColor: Colors.teal,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white
                                                ),
                                                decoration: getInputDecoration(
                                                    hint: "Choose Category",
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white
                                                    ),
                                                    darkMode: isDarkMode(context),
                                                    errorColor: Theme.of(context).colorScheme.error
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
                                            return const Text("");
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 27,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.done,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          title = val!;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        onFieldSubmitted: (title) => context.read<PermissionBloc>()
                                        .add(ValidatePermissionFieldsEvent(_key)),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.key_rounded,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: "Title of the Permission",
                                            hintStyle: const TextStyle(
                                                color: Colors.white
                                            ),
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error
                                        ),
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
                                              .read<PermissionBloc>()
                                              .add(ValidatePermissionFieldsEvent(_key)),
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
                                            onPressed: () => {
                                              _key.currentState?.reset(),
                                              _toggleFormShown()
                                            },
                                            label: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),
                                            ),
                                          )

                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                              : const Text(''),
                        );
                      },
                    )
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
    onPressed: () => {
      context.read<PermissionBloc>()
    .add(PermissionDeleteInitEvent()),
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
      "Delete Permission ?",
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