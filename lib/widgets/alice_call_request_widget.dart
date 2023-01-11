import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'alice_base_call_details_widget.dart';

class AliceCallRequestWidget extends StatefulWidget {
  final dynamic result;

  AliceCallRequestWidget(this.result);

  @override
  State<StatefulWidget> createState() {
    return _AliceCallRequestWidget();
  }
}

class _AliceCallRequestWidget
    extends AliceBaseCallDetailsWidgetState<AliceCallRequestWidget> {
  Response get _result => widget.result;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    final headers = _result.requestOptions.headers;
    var headersContent = "Headers are empty";
    if (headers.isNotEmpty) {
      headersContent = "";
    }
    rows.add(getListRow("Headers: ", headersContent));
    _result.requestOptions.headers.forEach((header, dynamic value) {
      rows.add(getListRow("   • $header:", value.toString()));
    });

    
    if (_result.requestOptions.data != null) {
      var data = _result.requestOptions.data;
      rows.add(getListRow("Data: ", ''));
      if (data is String) {
        data = jsonDecode(data);
        rows.add(getListRow("   • data:", data));
      } else if (data is Map) {
        data.forEach((data, dynamic value) {
          rows.add(getListRow("   • $data:", value.toString()));
        });
      } else if (data is FormData) {
        data.fields.forEach(
              (field) {
            rows.add(getListRow("   • ${field.key}:", field.value));
          },
        );
      } else {
        rows.add(getListRow("Data: ", 'Data is empty'));
      }
    } else {
      rows.add(getListRow("Data: ", 'Data is empty'));
    }

    final queryParameters = _result.requestOptions.queryParameters;
    var queryParametersContent = "Query parameters are empty";
    if (queryParameters.isNotEmpty) {
      queryParametersContent = "";
    }
    rows.add(getListRow("Query Parameters: ", queryParametersContent));
    _result.requestOptions.queryParameters.forEach((query, dynamic value) {
      rows.add(getListRow("   • $query:", value.toString()));
    });

    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView(children: rows),
    );
  }
}
