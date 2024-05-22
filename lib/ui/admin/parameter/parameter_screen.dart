import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/parameter.dart';
import 'package:gaindesat_ddp_client/services/admin/parameter_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/parameter/parameter_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

import '../../../services/helper.dart';

class ParameterScreen extends StatefulWidget {
  const ParameterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController uniteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? name, unite, description, deleteParameterUUID, updatingParameterUUID;
  bool _showForm = false;
  bool _updating = false;
  late final Future<List<Parameter>> futureParameters;

  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
      _updating = false;
      nameController.clear();
      uniteController.clear();
      descriptionController.clear();
    });
  }

  void _toggleUpdate(Parameter parameter) {
    setState(() {
      _showForm = true;
      _updating = true;
      name = parameter.name;
      unite = parameter.unite;
      description = parameter.description;
      updatingParameterUUID = parameter.uuid;
      nameController.text = name!;
      uniteController.text = name!;
      descriptionController.text = description!;
    });
  }

  @override
  void initState() {
    super.initState();
    futureParameters = ParameterService().fetchParameters();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParameterBloc>(
      create: (context) => ParameterBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Parameter Management',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.teal,
            iconTheme: const IconThemeData(color: Colors.tealAccent),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<ParameterBloc, ParameterManagementState>(
                listener: (context, state) async {
                  await context.read<LoadingCubit>().hideLoading();
                  if (state.parameterState == ParameterState.addSuccess ||
                      state.parameterState == ParameterState.updateSuccess ||
                      state.parameterState == ParameterState.deleteSuccess) {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ParameterScreen(),
                      ),
                    );
                    showSnackBarSuccess(context, state.message!);
                  } else {
                    if (state.parameterState == ParameterState.addError ||
                        state.parameterState == ParameterState.updateError ||
                        state.parameterState == ParameterState.deleteError) {
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const ParameterScreen(),
                        ),
                      );
                      showSnackBar(context, state.message!);
                    }
                  }
                },
              ),
              BlocListener<ParameterBloc, ParameterManagementState>(
                listener: (context, state) async {
                  if (state.parameterState == ParameterState.deleteInit) {
                    await context.read<LoadingCubit>().showLoading(
                      context,
                      "Deleting Parameter !!",
                      false,
                    );
                    if (!mounted) return;
                    context.read<ParameterBloc>().add(
                      ParameterDeleteEvent(parameterUUID: deleteParameterUUID!),
                    );
                  }
                },
              ),
              BlocListener<ParameterBloc, ParameterManagementState>(
                listener: (context, state) async {
                  if (state.parameterState == ParameterState.validParameterFields) {
                    await context.read<LoadingCubit>().showLoading(
                      context,
                      _updating ? "Updating Parameter!! Please wait" : "Adding a Parameter!! Please wait",
                      false,
                    );
                    if (!mounted) return;
                    _updating
                        ? context.read<ParameterBloc>().add(
                      ParameterUpdateEvent(
                        parameter: Parameter(
                          uuid: updatingParameterUUID,
                          name: name!,
                          unite: unite!,
                          description: description!
                        ),
                      ),
                    )
                        : context.read<ParameterBloc>().add(
                      ParameterAddEvent(parameter: Parameter(name: name!, unite: unite!, description: description!)),
                    );
                  }
                },
              ),
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
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: FloatingActionButton.extended(
                            heroTag: 'AddParameter',
                            backgroundColor: Colors.teal,
                            tooltip: 'Add New Parameter',
                            elevation: 10,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.tealAccent,
                            ),
                            onPressed: _toggleFormShown,
                            label: const Text(
                              'Add Parameter',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FutureBuilder<List<Parameter>>(
                        future: futureParameters,
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
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: const AssetImage('assets/images/welcome_image.png'),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: ListTile(
                                                title: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 0, right: 90),
                                                      child: Text(
                                                        'Name: ',
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0, left: 66),
                                                      child: Text(
                                                        snapshot.data![index].name,
                                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 21),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                subtitle: Stack(
                                                  alignment: Alignment.topLeft,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(top: 0, right: 0),
                                                      child: Text(
                                                        'Unite: ',
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0, left: 66),
                                                      child: Text(
                                                        snapshot.data![index].unite,
                                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 21),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 75, left: 0, right: 34),
                                              child: FloatingActionButton(
                                                heroTag: "update-parameter_$index",
                                                backgroundColor: Colors.teal,
                                                mini: false,
                                                child: const Icon(
                                                  Icons.update,
                                                  color: Colors.tealAccent,
                                                ),
                                                onPressed: () {
                                                  _toggleUpdate(snapshot.data![index]);
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 75, left: 34),
                                              child: FloatingActionButton(
                                                heroTag: "delete-parameter_$index",
                                                backgroundColor: Colors.red.shade900,
                                                mini: false,
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.tealAccent,
                                                ),
                                                onPressed: () => {
                                                  deleteParameterUUID = snapshot.data![index].uuid,
                                                  showAlertDialog(context),
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
                                childAspectRatio: 3 / 1,
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
                    BlocBuilder<ParameterBloc, ParameterManagementState>(
                      buildWhen: (old, current) =>
                      current.parameterState is ParameterManagementState && old != current,
                      builder: (context, state) {
                        if (state.parameterState == ParameterState.failureFillParameterFields) {
                          _validate = AutovalidateMode.onUserInteraction;
                        }
                        return Card(
                          elevation: 12,
                          color: Colors.teal,
                          shadowColor: Colors.blue,
                          child: _showForm
                              ? SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 46),
                              child: Form(
                                key: _key,
                                autovalidateMode: _validate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40, right: 16, left: 16, bottom: 12),
                                      child: Text(
                                        !_updating ? 'Create New Parameter' : 'Update Parameter',
                                        style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14, right: 24, left: 24),
                                      child: TextFormField(
                                        controller: nameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          name = val!;
                                        },
                                        style: const TextStyle(fontSize: 18.0, color: Colors.white),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: 'Parameter name',
                                          hintStyle: const TextStyle(color: Colors.white),
                                          darkMode: isDarkMode(context),
                                          errorColor: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14, right: 24, left: 24),
                                      child: TextFormField(
                                        controller: uniteController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          unite = val!;
                                        },
                                        style: const TextStyle(fontSize: 18.0, color: Colors.white),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: 'Parameter unite',
                                          hintStyle: const TextStyle(color: Colors.white),
                                          darkMode: isDarkMode(context),
                                          errorColor: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 27, right: 24, left: 24),
                                      child: TextFormField(
                                        controller: descriptionController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          description = val!;
                                        },
                                        style: const TextStyle(fontSize: 18.0, color: Colors.white),
                                        onFieldSubmitted: (name) => context.read<ParameterBloc>().add(ValidateParameterFieldsEvent(_key)),
                                        keyboardType: TextInputType.text,
                                        cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.tealAccent,
                                            size: 24,
                                          ),
                                          hint: 'Parameter description',
                                          hintStyle: const TextStyle(color: Colors.white),
                                          darkMode: isDarkMode(context),
                                          errorColor: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 27, right: 23, left: 0, bottom: 0),
                                          child: FloatingActionButton.extended(
                                            heroTag: "submit",
                                            backgroundColor: Colors.teal,
                                            tooltip: 'Submit',
                                            elevation: 10,
                                            icon: const Icon(
                                              Icons.create,
                                              color: Colors.tealAccent,
                                            ),
                                            onPressed: () => context.read<ParameterBloc>().add(ValidateParameterFieldsEvent(_key)),
                                            label: const Text(
                                              'Submit',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0, right: 0, left: 23, bottom: 0),
                                          child: FloatingActionButton.extended(
                                            heroTag: "cancel",
                                            backgroundColor: Colors.red.shade900,
                                            tooltip: 'Cancel',
                                            elevation: 10,
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.tealAccent,
                                            ),
                                            onPressed: () => {
                                              _key.currentState?.reset(),
                                              nameController.clear(),
                                              uniteController.clear(),
                                              descriptionController.clear(),
                                              _toggleFormShown(),
                                            },
                                            label: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.white),
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
      }),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget deleteButton = FloatingActionButton.extended(
    onPressed: () => {
      context.read<ParameterBloc>().add(ParameterDeleteInitEvent()),
      Navigator.of(context).pop(),
    },
    icon: const Icon(
      Icons.done_all_outlined,
      color: Colors.tealAccent,
    ),
    label: const Text(
      'Delete',
      style: TextStyle(color: Colors.tealAccent),
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
      style: TextStyle(color: Colors.tealAccent),
    ),
    backgroundColor: Colors.red.shade900,
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.teal,
    alignment: Alignment.center,
    title: const Text(
      'Confirmation Dialog',
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 23),
    ),
    content: const Text(
      "Delete Parameter ?",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w300),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      deleteButton,
      cancelButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
