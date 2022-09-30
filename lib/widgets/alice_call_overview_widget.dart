import 'package:flutter/material.dart';
import 'package:dio/src/response.dart';
import 'alice_base_call_details_widget.dart';

class AliceCallOverviewWidget extends StatefulWidget {
  final Response result;

  const AliceCallOverviewWidget({Key? key, required this.result}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AliceCallOverviewWidget();
  }
}

class _AliceCallOverviewWidget
    extends AliceBaseCallDetailsWidgetState<AliceCallOverviewWidget> {
  Response get _result => widget.result;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    rows.add(getListRow("Method: ", _result.requestOptions.method));
    rows.add(getListRow("Server: ", _result.requestOptions.baseUrl));
    rows.add(getListRow("Endpoint: ", _result.realUri.path));
    rows.add(getListRow("Bytes send:", (_result.headers.toString().length*4/1000).toString()+' kB'));
    rows.add(getListRow("Bytes received:", (_result.data.toString().length*4/1000).toString()+' kB'));
    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView(children: rows),
    );
  }
}
