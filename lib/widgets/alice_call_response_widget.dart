import 'package:flutter/material.dart';
import 'package:dio/src/response.dart';
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
    // if (!_call.loading) {
    //   rows.addAll(_buildGeneralDataRows());
    //   rows.addAll(_buildHeadersRows());
    //   rows.addAll(_buildBodyRows());

    rows.addAll(_buildStatusRow());
    rows.addAll(_buildBodyRows());
      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    }

  @override
  void dispose() {
    // _betterPlayerController?.dispose();
    super.dispose();
  }

  // List<Widget> _buildGeneralDataRows() {
  //   final List<Widget> rows = [];
  //   // rows.add(getListRow("Received:", _call.response!.time.toString()));
  //   // rows.add(getListRow("Bytes received:", formatBytes(_call.response!.size)));
  //
  //   const status = "_call.response!.status";
  //   var statusText = status;
  //   if (status == -1) {
  //     statusText = "Error";
  //   }
  //
  //   rows.add(getListRow("Status:", statusText));
  //   return rows;
  // }

  // List<Widget> _buildHeadersRows() {
  //   final List<Widget> rows = [];
  //   const headers = "_call.response!.headers";
  //   var headersContent = "Headers are empty";
  //   if (headers.isNotEmpty) {
  //     headersContent = "";
  //   }
  //   rows.add(getListRow("Headers: ", headersContent));
  //   return rows;
  // }

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
        formatBody(widget.result.data.toString(), "");
    rows.add(getListRow("Body:", bodyContent));
    return rows;
  }
}
