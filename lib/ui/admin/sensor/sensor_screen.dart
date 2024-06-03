import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/full_station.dart';
import 'package:gaindesat_ddp_client/models/parameter.dart';
import 'package:gaindesat_ddp_client/services/admin/parameter_services.dart';
import 'package:gaindesat_ddp_client/services/admin/sensor_service.dart';
import 'package:gaindesat_ddp_client/services/admin/staion_service.dart';
import 'package:gaindesat_ddp_client/ui/admin/sensor/sensor_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../models/sensor.dart';
import '../../../services/helper.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State createState() => _SensorScreenState();
}

class PillShapedContainer extends StatelessWidget {
  final String text;

  const PillShapedContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade800,
        borderRadius: BorderRadius.circular(53.0),
        border: Border.all(
          color: Colors.tealAccent,
          width: 1.7,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w400
        ),
      ),
    );
  }
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
  late final Future<List<Parameter>> futuresParameters;
  late final Future<List<Sensor>> futureSensors;
  List<Parameter> _selectedParameters = [];
  FullStation? stationValue;
  List<String> sensorTypes = ["PLS-C", "WS601", "SE200"];
  String? deleteSensorUUID;
  String? code, name, sensorType, stationUUID;
  bool _showForm = false;
  bool _updating = false;
  late List<String> parameters = [];
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
      parameters = sensor.parameters;
    });
  }

  @override
  void initState() {
    super.initState();
    futureSensors = SensorService().fetchSensors();
    futureStations = StationService().fetchStations();
    futuresParameters = ParameterService().fetchParameters();
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
            backgroundColor: Colors.teal.shade900,
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
                            stationUuid: stationValue?.uuid
                        ))
                    ) :
                      context.read<SensorBloc>().add(
                        SensorAddEvent(sensor: Sensor(
                            code: code,
                            name: name,
                            type: sensorType,
                            parameters: parameters,
                            stationUuid: stationValue?.uuid
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
                            backgroundColor: Colors.teal.shade900,
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
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Card(
                                      color: Colors.teal.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.sensors_rounded,
                                                  size: 24,
                                                  color: Colors.tealAccent,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Code: ${snapshot.data?[index].code}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Name: ${snapshot.data?[index].name}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Text(
                                              'Type: ${snapshot.data?[index].type}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Parameters:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: snapshot.data![index].parameters
                                                  .map((parameter) => PillShapedContainer(text: parameter))
                                                  .toList(),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                FloatingActionButton(
                                                  heroTag: 'update-sensor_$index',
                                                  backgroundColor: Colors.teal,
                                                  child: const Icon(
                                                    Icons.update,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    _toggleFormShown();
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                FloatingActionButton(
                                                  heroTag: 'delete-sensor_$index',
                                                  backgroundColor: Colors.red.shade900,
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () => {
                                                    deleteSensorUUID = snapshot.data![index].uuid,
                                                    showAlertDialog(context)
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                /*Padding(
                                  padding: const EdgeInsets.all(0),
                                   child: SensorCard(sensor: snapshot.data![index])
                                );*/
                              },
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 700,
                                childAspectRatio: 7/3,
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
                                              hintStyle: const TextStyle(color: Colors.white),
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
                                            left: 24,
                                            right: 24
                                          ),
                                        child: FutureBuilder<List<Parameter>>(
                                          future: futuresParameters,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const CircularProgressIndicator();
                                            }
                                            return MultiSelectDialogField(
                                              itemsTextStyle: const TextStyle(color: Colors.white),
                                              unselectedColor: Colors.teal,
                                              confirmText: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400
                                                )
                                              ),
                                              cancelText: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              selectedItemsTextStyle: const TextStyle(
                                                color: Colors.white
                                              ),
                                              selectedColor: Colors.teal.shade900,
                                              dialogHeight: MediaQuery.of(context).size.height/7,
                                              dialogWidth: MediaQuery.of(context).size.width/4,
                                              backgroundColor: Colors.teal,
                                              checkColor: Colors.teal,
                                              title: const Text(
                                                  "Select Parameters",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                                items: snapshot.data!
                                                    .map((parameter) => MultiSelectItem<Parameter>(parameter, parameter.name))
                                                .toList(),
                                                listType: MultiSelectListType.CHIP,
                                                decoration: BoxDecoration(
                                                  color: Colors.teal,
                                                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                                                  border: Border.all(color: Colors.tealAccent, width: 2)
                                                ),
                                                buttonIcon: const Icon(
                                                  Icons.arrow_drop_down_circle_rounded,
                                                  color: Colors.tealAccent,
                                                ),
                                                buttonText: const Text(
                                                  "Select Parameters",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16
                                                  ),
                                                ),
                                                onConfirm: (values) {
                                                  _selectedParameters = values.cast<Parameter>();//.map((parameter) => parameter.name).toList();
                                                  setState(() {
                                                    parameters = _selectedParameters.map((parameter) => parameter.name).toList();
                                                  });
                                                },
                                              chipDisplay: MultiSelectChipDisplay(
                                                  textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)
                                                ),
                                                chipColor: Colors.teal.shade900,
                                                onTap: (value) {
                                                  setState(() {
                                                    _selectedParameters.remove(value);
                                                    parameters = _selectedParameters.map((parameter) => parameter.name).toList();
                                                  });
                                                }
                                              ),
                                            );
                                          },
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 44,
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

showAlertDialog(BuildContext context) {
  Widget deleteButton = FloatingActionButton.extended(
    onPressed: () => {
      context.read<SensorBloc>().add(SensorDeleteInitEvent()),
      Navigator.of(context).pop()
    },
    icon: const Icon(
      Icons.done_all_outlined,
      color: Colors.tealAccent
    ),
    label: const Text(
      'Delete',
      style: TextStyle(color: Colors.tealAccent)
    ),
    backgroundColor: Colors.teal
  );

  Widget cancelButton = FloatingActionButton.extended(
    onPressed: () => Navigator.of(context).pop(),
    icon: const Icon(
      Icons.clear,
      color: Colors.tealAccent
    ),
    label: const Text(
      'Cancel',
      style: TextStyle(color: Colors.tealAccent)
    ),
    backgroundColor: Colors.red.shade900
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.teal,
    alignment: Alignment.center,
    title: const Text(
      'Confirmation Dialog',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 23
      )
    ),
    content: const Text(
      'Delete Sensor ?',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w300)
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