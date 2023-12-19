import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/services/admin/staion_service.dart';
import 'package:gaindesat_ddp_client/ui/admin/stations/station_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import '../../../models/partner.dart';
import '../../../models/station.dart';
import '../../../services/admin/partner_services.dart';
import '../../../services/helper.dart';
class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _keys = GlobalKey();
  String? code, name, deleteStationUUID, partnerUUID;
  double? longitude, latitude, elevation;
  bool _showFrom = false;
  ReducePartner? partnerValue;
  late final Future<List<Station>> futureStations;
  late final Future<List<ReducePartner>> futurePartners;
  void _toggleFormShow() {
    setState(() {
      _showFrom = !_showFrom;
    });
  }

  @override
  void initState() {
    super.initState();
    futureStations = StationService().fetchStations();
    futurePartners = PartnerService().fetchPartners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StationBloc>(
      create: (context) => StationBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Stations Management',
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
          body: MultiBlocListener(
            listeners: [
              BlocListener<StationBloc, StationManagementState>(
                listener: (context, state) async {
                  await context.read<LoadingCubit>().hideLoading();
                  if((state.stationState == StationState.addSuccess)
                  || (state.stationState == StationState.deleteSuccess)
                  || (state.stationState == StationState.updateSuccess)) {
                    if(!mounted) return;
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const StationScreen()));
                    showSnackBarSuccess(context, state.message!);
                  } else {
                    if ((state.stationState == StationState.addError)
                    || (state.stationState == StationState.deleteError)
                    || (state.stationState == StationState.updateError)) {
                      if(!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const StationScreen()));
                      showSnackBar(context, state.message!);
                    }
                  }
                },
              ),
              BlocListener<StationBloc, StationManagementState>(
                listener: (context, state) async {
                  if(state.stationState == StationState.deleteInit) {
                    await context.read<LoadingCubit>().showLoading(context, "Deleting Station", false);
                    if(!mounted) return;
                    context.read<StationBloc>().add(
                      StationDeleteEvent(stationUUID: deleteStationUUID!)
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
                          padding: const EdgeInsets.only(
                            left: 0,
                            right: 0
                          ),
                          child: FloatingActionButton.extended(
                              heroTag: "AddStation",
                              backgroundColor: Colors.teal,
                              tooltip: "Add new Station",
                              elevation: 10,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.tealAccent,
                              ),
                              onPressed: _toggleFormShow,
                              label: const Text(
                                "Add Station",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12
                      ),
                      child: FutureBuilder<List<Station>> (
                        future: futureStations,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  color: Colors.teal,
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
                                        Padding(
                                          padding: EdgeInsets.zero,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 12,
                                                    right: 7,
                                                    left: 7
                                                ),
                                                child: Icon(
                                                  Icons.tour_outlined,
                                                  size: 33,
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 17,
                                                    left: 7,
                                                    right: 7
                                                ),
                                                child: Text(
                                                  'Ref: ${snapshot.data![index].code}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 21
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 17,
                                                    left: 17,
                                                    right: 7
                                                ),
                                                child: Text(
                                                  'Station: ${snapshot.data![index].name}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 21
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 53,
                                            bottom: 2
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 12,
                                                    right: 7,
                                                    left: 7
                                                ),
                                                child: Icon(
                                                  Icons.place_outlined,
                                                  size: 33,
                                                  color: Colors.tealAccent,
                                                  grade: 2.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 17,
                                                    left: 7,
                                                    right: 7
                                                ),
                                                child: Text(
                                                  'Lat: ${snapshot.data![index].latitude} °',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 21
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 17,
                                                    left: 17,
                                                    right: 7
                                                ),
                                                child: Text(
                                                  'Long: ${snapshot.data![index].longitude} °',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 21
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 17,
                                                    left: 17,
                                                    right: 0
                                                ),
                                                child: Text(
                                                  'Elev: ${snapshot.data![index].elevation} m',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 21
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                              top: 117
                                            ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 3
                                                  ),
                                                child: FloatingActionButton(
                                                  heroTag: "update_station",
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
                                                    right: 10,
                                                    bottom: 3
                                                  ),
                                                child: FloatingActionButton(
                                                  heroTag: "delete_station",
                                                  backgroundColor: Colors.red.shade900,
                                                  mini: false,
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.tealAccent,
                                                  ),
                                                  onPressed: () => {
                                                    deleteStationUUID = snapshot.data![index].uuid,
                                                    showAlertDialog(context)
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
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
                      )
                    ),
                    BlocBuilder<StationBloc, StationManagementState>(
                      buildWhen: (old, current) =>
                      current.stationState is StationManagementState && old != current,
                      builder: (context, state) {
                        if (state.stationState == StationState.failureFillStationFields) {
                          _validate = AutovalidateMode.onUserInteraction;
                        }
                        return Card(
                          elevation: 12,
                          color: Colors.teal,
                          child: _showFrom ?
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
                                        'Create new Station',
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
                                        validator: validateCommonField,
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
                                          prefixIcon: const Icon(
                                            Icons.key_rounded,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: 'Code of the station',
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
                                          top: 34,
                                          right: 24,
                                          left: 24
                                        ),
                                      child: TextFormField(
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
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.place_sharp,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: "Nom de la station",
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
                                          top: 34,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateDoubleField,
                                        onSaved: (String? val) {
                                          longitude = double.parse(val!);
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.flag_sharp,
                                              color: Colors.tealAccent,
                                            ),
                                            suffixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0
                                              ),
                                              child: Text(
                                                '°',
                                                style: TextStyle(
                                                    fontSize: 31,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            hint: "Longitude",
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
                                          top: 34,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateDoubleField,
                                        onSaved: (String? val) {
                                          latitude = double.parse(val!);
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.flag_sharp,
                                              color: Colors.tealAccent,
                                            ),
                                            suffixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0
                                              ),
                                              child: Text(
                                                '°',
                                                style: TextStyle(
                                                    fontSize: 31,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            hint: "Latitude",
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
                                          top: 34,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.next,
                                        validator: validateDoubleField,
                                        onSaved: (String? val) {
                                          elevation = double.parse(val!);
                                        },
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        keyboardType: TextInputType.number,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.flag_sharp,
                                              color: Colors.tealAccent,
                                            ),
                                            suffixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                top: 3
                                              ),
                                              child: Text(
                                                'm',
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                            hint: "Elevation",
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
                                          top: 34,
                                          right: 24,
                                          left: 24
                                      ),
                                      child: FutureBuilder<List<ReducePartner>>(
                                        future: futurePartners,
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData) {
                                            return SizedBox(
                                              width: 300,
                                              child: DropdownButtonFormField(
                                                key: _keys,
                                                dropdownColor: Colors.teal,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                ),
                                                decoration: getInputDecoration(
                                                  hint: 'Choose PartnerShip',
                                                  hintStyle: const TextStyle(color: Colors.white),
                                                  darkMode: isDarkMode(context),
                                                  errorColor: Theme.of(context).colorScheme.error
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
                                            onPressed: () => context
                                                .read<StationBloc>()
                                                .add(ValidateStationsFieldsEvent(_key)),
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
                                                _toggleFormShow()
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
        context.read<StationBloc>()
        .add(StationsDeleteInitEvent()),
        Navigator.of(context).pop()
      },
    icon: const Icon(
      Icons.done_all_outlined,
      color: Colors.tealAccent,
    ),
    label: const Text(
      'Delete',
      style: TextStyle(
        color: Colors.teal
      ),
    ),
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
      "Delete Station ?",
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