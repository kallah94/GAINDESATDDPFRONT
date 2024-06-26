import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/partner/partner_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

import '../../../services/helper.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? code, name, deletePartnerUUID, updatingPartnerUUID;
  bool _showForm = false;
  bool _updating = false;
  late final Future<List<ReducePartner>> futurePartners;
  void _toggleFromShown() {
    setState(() {
      _showForm = !_showForm;
      _updating = false;
      codeController.clear();
      nameController.clear();
    });
  }
  
  void _toggleUpdate(ReducePartner reducePartner) {
    setState(() {
      _showForm = true;
      _updating = true;
      code = reducePartner.code;
      name = reducePartner.name;
      updatingPartnerUUID = reducePartner.uuid;
      codeController.text = code!;
      nameController.text = name!;
    });
  }
  @override
  void initState() {
    super.initState();
    futurePartners = PartnerService().fetchPartners();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<PartnerBloc>(
      create: (context) => PartnerBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Partner Management',
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
              BlocListener<PartnerBloc, PartnerManagementState>(
                listener: (context, state) async {
                  await context.read<LoadingCubit>().hideLoading();
                  if((state.partnerState == PartnerState.addSuccess)
                  || (state.partnerState == PartnerState.updateSuccess)
                  || (state.partnerState == PartnerState.deleteSuccess)) {
                    if (!mounted) return;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const PartnerScreen()
                        ));
                    showSnackBarSuccess(context, state.message!);
                  } else {
                    if ((state.partnerState == PartnerState.addError)
                    || (state.partnerState == PartnerState.updateError)
                    || (state.partnerState == PartnerState.deleteError)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const PartnerScreen()
                          ));
                      showSnackBar(context, state.message!);
                    }
                  }
                },
              ),
              BlocListener<PartnerBloc, PartnerManagementState>(
                  listener: (context, state) async {
                    if (state.partnerState == PartnerState.deleteInit) {
                      await context.read<LoadingCubit>().showLoading(
                          context, "Deleting Partner !!", false);
                      if (!mounted) return;
                      context.read<PartnerBloc>().add(
                          PartnerDeleteEvent(partnerUUID: deletePartnerUUID!));
                    }
                  }
              ),
              BlocListener<PartnerBloc, PartnerManagementState>(
                listener: (context, state) async {
                  if (state.partnerState == PartnerState.validPartnerFields) {
                    await context.read<LoadingCubit>().showLoading(context, _updating ? "Updating Partner!! Please wait" : "Adding a Partner!! Please wait", false);
                    if (!mounted) return;
                    _updating ? context.read<PartnerBloc>().add(
                      PartnerUpdateEvent(partner: Partner(uuid: updatingPartnerUUID, code: code!, name: name!))
                    ) :
                    context.read<PartnerBloc>().add(
                      PartnerAddEvent(partner: Partner(code: code!, name: name!)));
                  }
                },
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
                              right: 0
                          ),
                          child: FloatingActionButton.extended(
                            heroTag: 'AddPartner',
                            backgroundColor: Colors.teal.shade900,
                            tooltip: 'Add New Partner',
                            elevation: 10,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.tealAccent,
                            ),
                            onPressed: _toggleFromShown,
                            label: const Text(
                              'Add Partner',
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
                      child: FutureBuilder<List<ReducePartner>> (
                        future: futurePartners,
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
                                              flex: 2,
                                              child: ListTile(
                                                  title: Stack(
                                                    alignment: Alignment.topLeft,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 0,
                                                            right: 90
                                                        ),
                                                        child: Text(
                                                            'Code: ',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 21)
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 0,
                                                            left: 66
                                                        ),
                                                        child: Text(
                                                            snapshot.data![index].code!,
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w300,
                                                                fontSize: 21)
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  subtitle: Stack(
                                                    alignment: Alignment.topLeft,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 0,
                                                            right: 0
                                                        ),
                                                        child: Text(
                                                            'Name: ',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 21)
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 0,
                                                            left: 66
                                                        ),
                                                        child: Text(
                                                          snapshot.data![index].name!,
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 21
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                title: const Icon(
                                                  Icons.person_pin,
                                                  color: Colors.tealAccent,
                                                  size: 32,
                                                  grade: 40,
                                                ),
                                                subtitle: Text(
                                                  snapshot.data![index].userCount.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white
                                                  ),
                                                  textAlign: TextAlign.center,
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
                                              padding: const EdgeInsets.only(
                                                  top: 75,
                                                  left: 0,
                                                  right: 34
                                              ),
                                              child: FloatingActionButton(
                                                heroTag: "update-partner_$index",
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
                                              padding: const EdgeInsets.only(
                                                  top: 75,
                                                  left: 34
                                              ),
                                              child: FloatingActionButton(
                                                heroTag: "delete-partner_$index",
                                                backgroundColor: Colors.red.shade900,
                                                mini: false,
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.tealAccent,
                                                ),
                                                onPressed: () => {
                                                  deletePartnerUUID =  snapshot.data![index].uuid,
                                                  showAlertDialog(context)
                                                }
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
                                mainAxisSpacing: 1,
                              ),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    BlocBuilder<PartnerBloc,  PartnerManagementState>(
                      buildWhen: (old, current) =>
                      current.partnerState is PartnerManagementState && old != current,
                      builder: (context, state) {
                        if (state.partnerState == PartnerState.failureFillPartnerFields) {
                          _validate = AutovalidateMode.onUserInteraction;
                        }
                        return Card(
                          elevation: 12,
                          color: Colors.teal.shade900,
                          shadowColor: Colors.blue,
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
                                     Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40,
                                          right: 16,
                                          left: 16,
                                          bottom: 12
                                      ),
                                      child: Text(!_updating ? 'Create New Partner' : 'Update Partner',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: TextFormField(
                                        controller: codeController,
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
                                              Icons.key,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: 'Code of the partner',
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
                                      child: TextFormField(
                                        controller: nameController,
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          name = val!;
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        onFieldSubmitted: (name) => context.read<PartnerBloc>()
                                        .add(ValidatePartnerFieldsEvent(_key)),
                                        keyboardType: TextInputType.name,
                                        cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.tealAccent,
                                              size: 24,
                                            ),
                                            hint: 'Partner name',
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
                                            heroTag: "submit",
                                            backgroundColor: Colors.teal,
                                            tooltip: 'Submit',
                                            elevation: 10,
                                            icon: const Icon(
                                              Icons.create,
                                              color: Colors.tealAccent,
                                            ),
                                            onPressed: () => context
                                            .read<PartnerBloc>()
                                            .add(ValidatePartnerFieldsEvent(_key)),
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
                                              codeController.clear(),
                                              nameController.clear(),
                                              _toggleFromShown()
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
      onPressed: () => {context.read<PartnerBloc>()
      .add(PartnerDeleteInitEvent()),
        Navigator.of(context).pop(),
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

  AlertDialog alert =  AlertDialog(
    backgroundColor: Colors.teal,
    alignment: Alignment.center,
    title: const Text('Confirmation Dialog'),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 23
    ),
    content: const Text(
        "Delete Partner ?",
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