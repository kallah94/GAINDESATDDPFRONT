import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/full_station.dart';
import 'package:gaindesat_ddp_client/models/station.dart';
import 'package:gaindesat_ddp_client/services/admin/sensor_service.dart';
import 'package:gaindesat_ddp_client/services/admin/staion_service.dart';
import 'package:gaindesat_ddp_client/ui/admin/sensor/sensor_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import '../../../models/sensor.dart';
import '../../../services/helper.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  final AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _keys = GlobalKey();
  final GlobalKey<FormState> _keys2 = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  late final Future<List<FullStation>> futureStations;

  FullStation? stationValue;
  List<String> sensorTypes = ["PLS-C", "WS601", "SE200"];
  String? deleteSensorUUID;
  String? code, name, sensorType, stationUUID;
  bool _showForm = false;
  bool _updating = false;
  late List<dynamic> parameters;
  late final Future<List<Sensor>> futureSensors;
  void _toggleFormShown() {
    setState(() {
      _showForm = !_showForm;
      _updating = false;
      codeController.clear();
      nameController.clear();
      typeController.clear();
    });
  }

  void _toggleUpdate(Sensor sensor) {
    setState(() {
      _showForm = true;
      _updating = true;
      code = sensor.code;
      name = sensor.name;
      sensorType = sensor.type;
      parameters = sensor.parameters!;
    });
  }

  @override
  void initState() {
    super.initState();
    futureSensors = SensorService().fetchSensors();
    futureStations = StationService().fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SensorBloc>(
      create: (context) => SensorBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sensors Management',
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
              BlocListener<SensorBloc, SensorManagementState>(
                  listener: (context, state) async {
                    await context.read<LoadingCubit>().hideLoading();
                    if ((state.sensorState == SensorState.addSuccess)
                    || (state.sensorState == SensorState.deleteSuccess)
                    || (state.sensorState == SensorState.updateSuccess)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const SensorScreen()));
                      showSnackBarSuccess(context, state.message!);
                    } else {
                      if ((state.sensorState == SensorState.addError)
                      || (state.sensorState == SensorState.deleteError)
                      || (state.sensorState == SensorState.updateError)) {
                        if (!mounted) return;
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => const SensorScreen()));
                        showSnackBar(context, state.message!);
                      }
                    }
                  }
              ),
              BlocListener<SensorBloc, SensorManagementState>(
                listener: (context, state) async {
                  if (state.sensorState == SensorState.deleteInit) {
                    await context.read<LoadingCubit>().showLoading(context, "Deleting Sensor", false);
                    if (!mounted) return;
                    context.read<SensorBloc>().add(
                      SensorDeleteEvent(sensorUUID: deleteSensorUUID!)
                    );
                  }
                },
              ),
              BlocListener<SensorBloc, SensorManagementState>(
                listener: (context, state) async {
                  if (state.sensorState == SensorState.validSensorFields) {
                    await context.read<LoadingCubit>().showLoading(context, _updating? "Updating Sensor!! please wait": "Adding a Sensor!! Please wait", false);
                    if (!mounted) return;
                    _updating ? context.read<SensorBloc>().add(
                        SensorUpdateEvent(sensor: Sensor(
                            code: code,
                            name: name,
                            type: sensorType,
                            parameters: parameters,
                            stationUuid: stationValue!.uuid
                        ))
                    ) :
                      context.read<SensorBloc>().add(
                        SensorAddEvent(sensor: Sensor(
                            code: code,
                            name: name,
                            type: sensorType,
                            stationUuid: stationValue!.uuid
                        ))
                      );
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
                            heroTag: 'AddSensor',
                            backgroundColor: Colors.teal,
                            tooltip: 'Add New Sensor',
                            elevation: 10,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.tealAccent,
                            ),
                            onPressed: _toggleFormShown,
                            label: const Text(
                              'Add Sensor',
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
                        bottom: 12,
                      ),
                      child: FutureBuilder<List<Sensor>> (
                        future: futureSensors,
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
                                  color: Colors.teal,
                                  semanticContainer: true,
                                  shadowColor: Colors.tealAccent,
                                  elevation: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                top: 0,
                                                right: 7,
                                                left: 7,
                                              ),
                                              child: Icon(
                                                Icons.tour_outlined,
                                                size: 23,
                                                color: Colors.tealAccent,
                                              )
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 0.0
                                              ),
                                              child: Text(
                                                  'Nom: ${snapshot.data![index].name!}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 21
                                                ),
                                              ),
                                            ),
                                             Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                  left: 12
                                                ),
                                               child: Text(
                                                 'Code: ${snapshot.data![index].code}',
                                                 style: const TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.w300,
                                                     fontSize: 21
                                                 ),
                                               ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 0,
                                                  right: 7,
                                                  left: 7,
                                                ),
                                                child: Icon(
                                                  Icons.tour_outlined,
                                                  size: 23,
                                                  color: Colors.tealAccent,
                                                )
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0,
                                                  left: 0.0
                                              ),
                                              child: Text(
                                                'Type: ${snapshot.data![index].type}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 17
                                                ),
                                              ),
                                            )
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
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    BlocBuilder<SensorBloc, SensorManagementState>(
                      buildWhen: (old, current) =>
                      current.sensorState is SensorManagementState && old != current,
                      builder: (context, state) {
                        if (state.sensorState == SensorState.failureFillSensorFields) {
                          _validate == AutovalidateMode.onUserInteraction;
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
                                        "Create new Sensor",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
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
                                              Icons.sensors_rounded,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: "Nom du capteur",
                                            hintStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
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
                                      child: DropdownButtonFormField(
                                        key: _keys,
                                        dropdownColor: Colors.teal,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white
                                        ),
                                        decoration: getInputDecoration(
                                            hint: "Choose sensor type",
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error
                                        ),
                                        isExpanded: true,
                                        value: sensorType,
                                        onChanged: (String? sType) {
                                          setState(() {
                                            sensorType = sType!;
                                          });
                                        },
                                        items: sensorTypes.map((String sType) {
                                          return
                                              DropdownMenuItem<String>(
                                                value: sType,
                                                child: Text(
                                                  sType,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              );
                                        }).toList(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 24.0,
                                        right: 24.0,
                                        left: 24.0
                                      ),
                                      child: FutureBuilder<List<FullStation>>(
                                        future: futureStations,
                                        builder: (context, snapshot) {
                                          return DropdownButtonFormField(
                                            key: _keys2,
                                            dropdownColor: Colors.teal,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white
                                            ),
                                            decoration: getInputDecoration(
                                                hint: 'Choose Station',
                                                hintStyle: const TextStyle(color: Colors.white),
                                                darkMode: isDarkMode(context),
                                                errorColor: Theme.of(context).colorScheme.error
                                            ),
                                            isExpanded: true,
                                            value: stationValue,
                                            onChanged: (FullStation? station) {
                                              setState(() {
                                                stationValue = station!;
                                              });
                                            },
                                            items: snapshot.data?.map<DropdownMenuItem<FullStation>>((FullStation station) {
                                              return
                                                DropdownMenuItem<FullStation>(
                                                    value: station,
                                                    child: Text(
                                                      station.name!,
                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                                    )
                                                );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 34,
                                          right: 24,
                                          left: 24
                                      ),
                                      child:TextFormField(
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
                                              Icons.sensor_window_sharp,
                                              color: Colors.tealAccent,
                                            ),
                                            hint: 'Code of the sensor',
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
                                            heroTag: "submit-sensor",
                                            backgroundColor: Colors.teal,
                                            tooltip: "Submit",
                                            elevation: 10,
                                            icon: const Icon(
                                              Icons.create,
                                              color: Colors.tealAccent,
                                            ),
                                            onPressed: () => context
                                              .read<SensorBloc>()
                                              .add(ValidateSensorFieldsEvent(_key)),
                                            label: const Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),
                                            )
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
                                            heroTag: "cancel-form",
                                            backgroundColor: Colors.red.shade900,
                                            tooltip: "Cancel",
                                            elevation: 10,
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.tealAccent,
                                            ),
                                            onPressed:() {
                                              _key.currentState?.reset();
                                              _keys.currentState?.reset();
                                              _keys2.currentState?.reset();// don't work yet
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
                          ) : const Text(''),
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