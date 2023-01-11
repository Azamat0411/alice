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
    // rows.add(getListRow("Started:", _call.request!.time.toString()));
    // rows.add(getListRow("Bytes sent:", formatBytes(_call.request!.size)));
    // rows.add(
    //   getListRow("Content type:", getContentType(_call.request!.headers)!),
    // );
    //
    // final dynamic body = _call.request!.body;
 /*   var bodyContent = "Body is empty";
    // if (body != null) {
    //   bodyContent = formatBody(body, getContentType(_call.request!.headers));
    // }
    rows.add(getListRow("Body:", bodyContent));
    final formDataFields = _call.request!.formDataFields;
    if (formDataFields?.isNotEmpty == true) {
      rows.add(getListRow("Form data fields: ", ""));
      formDataFields!.forEach(
        (field) {
          rows.add(getListRow("   • ${field.name}:", field.value));
        },
      );
    }
    final formDataFiles = _call.request!.formDataFiles;
    if (formDataFiles?.isNotEmpty == true) {
      rows.add(getListRow("Form data files: ", ""));
      formDataFiles!.forEach(
        (field) {
          rows.add(
            getListRow(
              "   • ${field.fileName}:",
              "${field.contentType} / ${field.length} B",
            ),
          );
        },
      );
    }*/

    final headers = _result.requestOptions.headers;
    var headersContent = "Headers are empty";
    if (headers.isNotEmpty) {
      headersContent = "";
    }
    rows.add(getListRow("Headers: ", headersContent));
    _result.requestOptions.headers.forEach((header, dynamic value) {
      rows.add(getListRow("   • $header:", value.toString()));
    });

    
    print('_AliceCallRequestWidget.build}');

    if(_result.requestOptions.data != null){
      var data = _result.requestOptions.data;
      print('_AliceCallRequestWidget.build ${data.runtimeType}');
      switch(data){
        case String:
          {
            print('_AliceCallRequestWidget.build String');
            data = jsonDecode(data);
            rows.add(getListRow("   • data:", data));
            break;
          }
        case FormData:{
          print('_AliceCallRequestWidget.build FormdData');
          break;
        }
        case Map<String, dynamic>:{
          print('_AliceCallRequestWidget.build Map');
          data.forEach((data, dynamic value) {
            rows.add(getListRow("   • $data:", value.toString()));
          });
          break;
        }
        default:{
          print('_AliceCallRequestWidget.build ${data.runtimeType is Map<String, dynamic>}');
        }
      }
    }else{
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
