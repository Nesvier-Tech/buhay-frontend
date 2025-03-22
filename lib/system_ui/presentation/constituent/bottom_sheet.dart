import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'map_dashboard.dart';
import '../login/otw.dart';
import '../../controller/constituent/map_marker_controller.dart';
import '../../controller/rescuer/map_results_controller.dart';
import '../../../features/map_error_dialog_box/presentation/map_error_dialog_box.dart';
import 'package:async/async.dart';

// Renamed to CustomBottomSheet as BottomSheet exists in flutter library
class CustomBottomSheet extends StatefulWidget {
  final MarkerController? markerController;

  const CustomBottomSheet({super.key, required this.markerController});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  late MapResultsController mapResultsController;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();

    mapResultsController = MapResultsController();
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

// Submit Route Function
  void _onSubmitRoute() async {
    if (timer.isActive) {
      timer.reset();
    } else {
      timer = RestartableTimer(Duration(milliseconds: 500), _submitAction);
    }
  }

  void _submitAction() async {
    // Checks if app has connection to server
    if (!(await mapResultsController.checkIfConnected())) {
      _showErrorDialog();
      return;
    }

    try {
      showDialog<AlertDialog>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sending Request...'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoadingAnimationWidget.discreteCircle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 100.0,
                ),
              ],
            ),
          );
        },
      );
      // Parse the request
      var request = await widget
          .markerController!.mapInteractiveSearchController
          .addRequestParsing();

      // Call the api for addRequest, response stores the response of the call (can be used to debug)
      var response = await widget
          .markerController!.mapResultsController.mapResultsApi
          .addRequest(request);

      print("Request ID: ${response["request_id"]}");

      if (context.mounted) {
        // Pop twice so we can go back to dashboard when pressing the back arrow from the otw page
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => MapDashboard(
                  personID: widget.markerController!
                      .mapInteractiveSearchController.personID)),
        );
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => OnTheWayPage(
                    requestId: response["request_id"],
                    mapInteractiveSearchController:
                        widget.markerController!.mapInteractiveSearchController,
                  )),
        );
      }
      // ignore: unused_local_variable
    } catch (e) {
      await showDialog<AlertDialog>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: <TextButton>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapConnectionErrorBox(controller: mapResultsController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable:
                      widget.markerController?.markerCountNotifier ??
                          ValueNotifier<int>(0),
                  builder: (context, markerCount, child) {
                    return Center(
                      child: Text(
                        widget.markerController?.startingPoint == null
                            ? "Select Starting Point"
                            : "Select ${widget.markerController!.maxMarkers - widget.markerController!.markerCounter} End Points",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ValueListenableBuilder<int>(
                    valueListenable:
                        widget.markerController?.markerCountNotifier ??
                            ValueNotifier<int>(0),
                    builder: (context, markerCount, child) {
                      return ElevatedButton(
                        onPressed: (widget.markerController?.startingPoint ==
                                    null ||
                                (widget.markerController?.endPoints.isEmpty ??
                                    true))
                            ? null
                            : () {
                                _onSubmitRoute();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(43, 58, 103, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
