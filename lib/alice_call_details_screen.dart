import 'package:flutter/material.dart' as alica_call_details_screen;
import 'widgets/alice_call_error_widget.dart';
import 'widgets/alice_call_overview_widget.dart';
import 'widgets/alice_call_request_widget.dart';
import 'widgets/alice_call_response_widget.dart';

class AliceCallDetailsScreen extends alica_call_details_screen.StatefulWidget {
  final dynamic result;

  const AliceCallDetailsScreen({alica_call_details_screen.Key? key, required this.result}) : super(key: key);

  @override
  _AliceCallDetailsScreenState createState() => _AliceCallDetailsScreenState();
}

class _AliceCallDetailsScreenState extends alica_call_details_screen.State<AliceCallDetailsScreen>
    with alica_call_details_screen.SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  alica_call_details_screen.Widget build(alica_call_details_screen.BuildContext context) {
    return alica_call_details_screen.Directionality(
      textDirection: alica_call_details_screen.Directionality.of(context),
      child: _buildMainWidget(),
    );
  }

  alica_call_details_screen.Widget _buildMainWidget() {
    return alica_call_details_screen.DefaultTabController(
      length: 4,
      child: alica_call_details_screen.Scaffold(
        appBar: alica_call_details_screen.AppBar(
          leading: alica_call_details_screen.IconButton(
            onPressed: (){
              alica_call_details_screen.Navigator.of(context).pop();
            },
            icon: const alica_call_details_screen.Icon(alica_call_details_screen.Icons.arrow_back),
          ),
          bottom: alica_call_details_screen.TabBar(
            indicatorColor: alica_call_details_screen.Colors.red,
            tabs: _getTabBars(),
          ),
          title: const alica_call_details_screen.Text('Alice - HTTP Call Details'),
        ),
        body: alica_call_details_screen.TabBarView(
          children: _getTabBarViewList(),
        ),
      ),
    );
  }

  List<alica_call_details_screen.Widget> _getTabBars() {
    final List<alica_call_details_screen.Widget> widgets = [];
    widgets.add(const alica_call_details_screen.Tab(icon: alica_call_details_screen.Icon(alica_call_details_screen.Icons.info_outline), text: "Overview"));
    widgets.add(const alica_call_details_screen.Tab(icon: alica_call_details_screen.Icon(alica_call_details_screen.Icons.arrow_upward), text: "Request"));
    widgets.add(const alica_call_details_screen.Tab(icon: alica_call_details_screen.Icon(alica_call_details_screen.Icons.arrow_downward), text: "Response"));
    widgets.add(const alica_call_details_screen.Tab(icon: alica_call_details_screen.Icon(alica_call_details_screen.Icons.warning), text: "Error",),
    );
    return widgets;
  }

  List<alica_call_details_screen.Widget> _getTabBarViewList() {
    final List<alica_call_details_screen.Widget> widgets = [];
    widgets.add(AliceCallOverviewWidget(result: widget.result));
    widgets.add(AliceCallRequestWidget(widget.result));
    widgets.add(AliceCallResponseWidget(widget.result));
    widgets.add(AliceCallErrorWidget(widget.result));
    return widgets;
  }
}
