import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/services/admin/staion_service.dart';
import 'package:gaindesat_ddp_client/ui/admin/stations/station_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

import '../../../models/station.dart';
import '../../../services/helper.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  String? code, name, deleteStationUUID;
  double? longitude, latitude, elevation;
  bool _showFrom = false;
  late final Future<List<Station>> futureStations;
  void _toggleFormShow() {
    setState(() {
      _showFrom = !_showFrom;
    });
  }

  @override
  void initState() {
    super.initState();
    futureStations = StationService().fetchStations();
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