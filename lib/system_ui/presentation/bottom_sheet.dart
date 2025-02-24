import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'map_result.dart';
import '../controller/map_marker_controller.dart';

// Renamed to CustomBottomSheet as BottomSheet exists in flutter library
class CustomBottomSheet extends StatefulWidget {
  final MarkerController? markerController;

  const CustomBottomSheet({super.key, required this.markerController});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

// Submit Route Function
  void _onSubmitRoute() async {
    try {
      showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Calculating Route...'),
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
      var parsedBody = await widget.markerController?.mapManualSearchController
          .manualSearchDataParsing();

      await widget.markerController?.mapResultsController.testRoutes();
      await widget.markerController?.mapResultsController.getRoute(parsedBody!);

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapResultPage(
                    mapResultsController:
                        widget.markerController!.mapResultsController,
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
                Center(
                    child: Text(
                  widget.markerController?.startingPoint == null
                      ? "Select Starting Point"
                      : "Select ${widget.markerController!.maxMarkers - widget.markerController!.markerCounter} End Points",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    onPressed:
                        (widget.markerController?.startingPoint == null ||
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
