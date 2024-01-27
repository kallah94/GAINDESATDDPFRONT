import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/mission_data.dart';
import 'package:gaindesat_ddp_client/services/admin/mission_data_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/collected-data/collected-data_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../services/helper.dart';

final int _rowsPerPage = 10;
List<MissionData> _paginatedMissionData = [];
class CollectedDataScreen extends StatefulWidget {
  const CollectedDataScreen({super.key});

  @override
  State createState() => _CollectedDataScreenState();
}

class _CollectedDataScreenState extends State<CollectedDataScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  String? startDate, endDate;
  bool _showForm = false;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  late final Future<List<MissionData>> futureMissionData;
  void _toggleFormShow() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2027)
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _dateController.text = "$picked";
      });
    }
  }

Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2027)
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = "${picked.toLocal()}";
      });
    }
}
  @override
  void initState() {
    super.initState();
    futureMissionData = MissionDataService().fetchMissionData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectedDataBloc>(
      create: (context) => CollectedDataBloc(),
      child: Builder(builder:  (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mission Data Management',
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
              BlocListener<CollectedDataBloc, CollectedDataManagementState>(
                  listener: (context, state) async {
                    await context.read<LoadingCubit>().hideLoading();
                    if (state.collectedDataState == CollectedDataState.requestCollectedDataSuccess) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const CollectedDataScreen()));
                      showSnackBarSuccess(context, state.message!);
                    } else if (state.collectedDataState == CollectedDataState.requestCollectedDataError) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const CollectedDataScreen()));
                      showSnackBar(context, state.message!);
                    }
                  }
              ),
              BlocListener<CollectedDataBloc, CollectedDataManagementState>(
                  listener: (context, state) async {
                    if(state.collectedDataState == CollectedDataState.validateCollectedDataDateFields) {
                      await context.read<LoadingCubit>().showLoading(context, "Getting mission data. Please wait !!", false);
                      if(!mounted) return;
                      context.read<CollectedDataBloc>().add(
                        CollectedDataRequestEvent(startDate: '$_selectedStartDate', endDate: '$_selectedEndDate')
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
                              heroTag: "missionData",
                              backgroundColor: Colors.teal,
                              tooltip: "Get Mission data",
                              elevation: 10,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.tealAccent,
                              ),
                              onPressed: _toggleFormShow,
                              label: const Text(
                                "Get Current Mission Data",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 45,
                                right: 0
                            ),
                            child: FloatingActionButton.extended(
                              heroTag: "exportMissionData",
                              backgroundColor: Colors.teal,
                              tooltip: "Export Mission data",
                              elevation: 10,
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.tealAccent,
                              ),
                              onPressed: _toggleFormShow,
                              label: const Text(
                                "Export Mission Data",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                          )
                        ],
                    ),
                    BlocBuilder<CollectedDataBloc, CollectedDataManagementState>(
                      buildWhen: (old, current) =>
                      current.collectedDataState is CollectedDataManagementState && old != current,
                      builder: (context, state) {
                        if (state.collectedDataState == CollectedDataState.failureFillCollectedDataDateFields) {
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
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.zero,
                                        child: Text(
                                          "Request Mission Data",
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
                                          controller: _dateController,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white
                                          ),
                                          decoration: getInputDecoration(
                                            hint: 'select start date',
                                            hintStyle: const TextStyle(
                                              color: Colors.white
                                            ),
                                            darkMode: isDarkMode(context),
                                            errorColor: Theme.of(context).colorScheme.error,
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.zero,
                                              child: IconButton(
                                                icon: const Icon(Icons.calendar_today),
                                                onPressed: () => _selectStartDate(context),
                                                color: Colors.tealAccent,
                                              ),
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () => _selectStartDate(context),
                                          onSaved: (String? value) {
                                            startDate = _selectedStartDate.toString();
                                            if (kDebugMode) {
                                              print('Selected Date: $_selectedStartDate');
                                            }
                                          },
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 34,
                                            right: 24,
                                            left: 24
                                        ),
                                        child: TextFormField(
                                          controller: _endDateController,
                                          textAlignVertical: TextAlignVertical.center,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white
                                          ),
                                          keyboardType: TextInputType.name,
                                          cursorColor: Colors.tealAccent,
                                          decoration: getInputDecoration(
                                              hint: "Select End Date",
                                              hintStyle: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.zero,
                                                child: IconButton(
                                                  icon: const Icon(Icons.calendar_today),
                                                  onPressed: () => _selectEndDate(context),
                                                  color: Colors.tealAccent,
                                                ),
                                              ),
                                              darkMode: isDarkMode(context),
                                              errorColor: Theme.of(context).colorScheme.error
                                          ),
                                          readOnly: true,
                                          onTap: () => _selectEndDate(context),
                                          onSaved: (value) {
                                            endDate = _selectedEndDate.toString();
                                            if (kDebugMode) {
                                              print('Selected Date: $_selectedEndDate');
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
                                              heroTag: "request-mission-data",
                                              backgroundColor: Colors.teal,
                                              tooltip: "Submit",
                                              elevation: 10,
                                              icon: const Icon(
                                                Icons.request_page,
                                                color: Colors.tealAccent,
                                              ),
                                             onPressed: () => context
                                              .read<CollectedDataBloc>()
                                              .add(ValidateCollectedDataDatesFieldsEvent(_key)),
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
                                              heroTag: "cancel-request-mission-data",
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
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ) : const Text('')
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 0
                      ),
                      child: FutureBuilder<List<MissionData>>(
                        future: futureMissionData,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return Column(
                              //padding: const EdgeInsets.all(15.0),
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: SfDataGrid(
                                      shrinkWrapColumns: false,
                                      shrinkWrapRows: false,
                                      source: MissionDataSource(missionData: snapshot.data!),
                                      columnWidthMode: ColumnWidthMode.fill,
                                      columns: <GridColumn>[
                                        GridColumn(
                                            columnName: "Paramètre",
                                            label: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text('PARAMETRE'),
                                            )
                                        ),
                                        GridColumn(
                                            columnName: "Valeur",
                                            label: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text('VALEUR'),
                                            )
                                        ),
                                        GridColumn(
                                            columnName: "Unité",
                                            label: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text('UNITÉ'),
                                            )
                                        ),
                                        GridColumn(
                                            columnName: "Date",
                                            label: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              child: const Text('DATE'),
                                            )
                                        ),
                                      ]),
                                ),
                               /* SizedBox(
                                  height: 60.0,
                                  child: SfDataPager(
                                    delegate: MissionDataSource(missionData: snapshot.data!),
                                    pageCount: snapshot.data!.length / _rowsPerPage,
                                    direction: Axis.horizontal,
                                  ),
                                )*/

                              ]
                            );

                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
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

class MissionDataSource extends DataGridSource {
  MissionDataSource({required List<MissionData> missionData}) {
    missionDataGridRows = missionData
        .map<DataGridRow>((item) => DataGridRow(cells: [
          DataGridCell<String>(columnName: "Paramètre", value: item.parameter),
          DataGridCell<String>(columnName: "Valeur", value: item.value.toString()),
          DataGridCell<String>(columnName: "Unité", value: item.unit),
          DataGridCell<String>(columnName: "Date", value: item.date)
    ])).toList(growable: true);
  }

  List<DataGridRow> missionDataGridRows = [];

  @override
  List<DataGridRow> get rows => missionDataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList(growable: true));
  }
}