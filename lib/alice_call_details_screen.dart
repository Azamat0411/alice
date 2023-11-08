import 'package:flutter/material.dart';
import 'widgets/alice_call_error_widget.dart';
import 'widgets/alice_call_overview_widget.dart';
import 'widgets/alice_call_request_widget.dart';
import 'widgets/alice_call_response_widget.dart';

class AliceCallDetailsScreen extends StatefulWidget {
  final dynamic result;

  const AliceCallDetailsScreen({Key? key, required this.result}) : super(key: key);

  @override
  _AliceCallDetailsScreenState createState() => _AliceCallDetailsScreenState();
}

class _AliceCallDetailsScreenState extends State<AliceCallDetailsScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: _buildMainWidget(),
    );
  }

  Widget _buildMainWidget() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          bottom: TabBar(
            indicatorColor: Colors.red,
            tabs: _getTabBars(),
          ),
          title: const Text('Alice - HTTP Call Details'),
        ),
        body: TabBarView(
          children: _getTabBarViewList(),
        ),
      ),
    );
  }

  List<Widget> _getTabBars() {
    final List<Widget> widgets = [];
    widgets.add(const Tab(icon: Icon(Icons.info_outline), text: "Overview"));
    widgets.add(const Tab(icon: Icon(Icons.arrow_upward), text: "Request"));
    widgets.add(const Tab(icon: Icon(Icons.arrow_downward), text: "Response"));
    widgets.add(const Tab(icon: Icon(Icons.warning), text: "Error",),
    );
    return widgets;
  }

  List<Widget> _getTabBarViewList() {
    final List<Widget> widgets = [];
    widgets.add(AliceCallOverviewWidget(result: widget.result));
    widgets.add(AliceCallRequestWidget(widget.result));
    widgets.add(AliceCallResponseWidget(widget.result));
    widgets.add(AliceCallErrorWidget(widget.result));
    return widgets;
  }
}
