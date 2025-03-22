import 'package:buhay/system_ui/controller/constituent/map_interactive_search.dart';
import 'package:buhay/system_ui/controller/constituent/map_manual_search_controller.dart';
// import 'package:buhay/system_ui/models.dart';
import 'package:flutter/material.dart';

class OnTheWayPage extends StatefulWidget {
  final int requestId;
  final MapManualSearchController? mapManualSearchController;
  final MapInteractiveSearchController? mapInteractiveSearchController;
  const OnTheWayPage(
      {super.key,
      required this.requestId,
      this.mapManualSearchController,
      this.mapInteractiveSearchController});
  @override
  State<OnTheWayPage> createState() => _OnTheWayPageState();
}

class _OnTheWayPageState extends State<OnTheWayPage> {
  late int requestId;
  late MapManualSearchController? mapManualSearchController;
  late MapInteractiveSearchController? mapInteractiveSearchController;

  @override
  void initState() {
    super.initState();

    requestId = widget.requestId;
    mapManualSearchController = widget.mapManualSearchController;
    mapInteractiveSearchController = widget.mapInteractiveSearchController;

    if (mapManualSearchController != null) {
      sendDataUsingManual();
    } else {
      sendDataUsingInteractive();
    }
  }

  void sendDataUsingManual() async {
    var request = await mapManualSearchController!.saveRouteParsing(requestId);
    await mapManualSearchController!.mapResultsController.mapResultsApi
        .saveRouteRequest(request);
  }

  void sendDataUsingInteractive() async {
    var request =
        await mapInteractiveSearchController!.saveRouteParsing(requestId);
    await mapInteractiveSearchController!.mapResultsController.mapResultsApi
        .saveRouteRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('On the Way'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Rescuer is on the Way!")],
        ),
      ),
    );
  }
}
