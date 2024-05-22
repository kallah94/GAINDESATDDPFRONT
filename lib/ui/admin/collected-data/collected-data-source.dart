import 'package:flutter/material.dart';

import '../../../models/mission_data.dart';

class _CollectedDataSource extends DataTableSource {
  final List<MissionData> data;

  _CollectedDataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final item = data[index];

    return DataRow(cells: [
      DataCell(Text(item.parameter!)),
      DataCell(Text(item.value.toString())),
      DataCell(Text(item.unit!)),
      DataCell(Text(item.date.toString()))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}