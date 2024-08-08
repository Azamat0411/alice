import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'alice_base_call_details_widget.dart';

class AliceCallResponseWidget extends StatefulWidget {
  final Response result;

  const AliceCallResponseWidget(this.result, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AliceCallResponseWidgetState();
  }
}

class _AliceCallResponseWidgetState
    extends AliceBaseCallDetailsWidgetState<AliceCallResponseWidget> {

  Response get _result => widget.result;
  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    rows.addAll(_buildStatusRow());
    rows.addAll(_buildBodyRows());
      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    }
  
  List<Widget> _buildStatusRow() {
    final List<Widget> rows = [];
    rows.add(getListRow("Status: ", widget.result.statusCode.toString()));
    return rows;
  }

  List<Widget> _buildBodyRows() {
    final List<Widget> rows = [];
    if(_result.statusCode == 200 || _result.statusCode == 201) {
      rows.addAll(_buildTextBodyRows());
    }else{
      rows.add(getListRow("Body", "{}"));
    }
    return rows;
  }

  List<Widget> _buildTextBodyRows() {
    final List<Widget> rows = [];
    final bodyContent =
        formatBody(widget.result.data, "");
    rows.add(getListRow("Body:", bodyContent));
    return rows;
  }
}
