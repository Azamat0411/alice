import 'package:flutter/material.dart';
import 'package:dio/src/response.dart';
import 'alice_base_call_details_widget.dart';

class AliceCallErrorWidget extends StatefulWidget {
  final Response result;

  const AliceCallErrorWidget(this.result, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AliceCallErrorWidgetState();
  }
}

class _AliceCallErrorWidgetState
    extends AliceBaseCallDetailsWidgetState<AliceCallErrorWidget> {
  Response get _result => widget.result;

  @override
  Widget build(BuildContext context) {
    if (_result.statusCode == 200 || _result.statusCode == 201) {
      return const Center(child: Text("Nothing to display here"));
    } else {
      final List<Widget> rows = [];
      final dynamic error = _result.data;
      var errorText = "Error is empty";
      if (error != null) {
        errorText = error.toString();
      }
      rows.add(getListRow("Error:", errorText));

      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    }
  }
}
