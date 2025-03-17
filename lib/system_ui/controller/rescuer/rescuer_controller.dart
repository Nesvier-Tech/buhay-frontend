import 'dart:async';
import 'dart:convert';
import 'package:buhay/system_ui/controller/map_results_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../api/rescuer/rescuer_api.dart';

class RescuerController extends MapResultsController {
  final String rescuerId;
  final RescuerApi rescuerApi;

  RescuerController({required this.rescuerId}) : rescuerApi = RescuerApi();

  WebSocketChannel? _channel; // Make _channel nullable
  final StreamController<List<Map<String, dynamic>>> _controller =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> data = [];
  String url = "buhay-backend-production.up.railway.app";

  // Public getter for the broadcast stream
  Stream<List<Map<String, dynamic>>> get stream => _controller.stream;

  void connectWebSocket() {
    // print("Connecting to WebSocket...");
    _channel = WebSocketChannel.connect(Uri.parse('wss://$url/ws/$rescuerId'));

    // print(_channel);

    // Add the current data to the stream immediately
    if (data.isNotEmpty && !_controller.isClosed) {
      _controller.sink.add(data);
    }

    _channel!.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      // print("WebSocket message: $decodedMessage");
      if (decodedMessage is List) {
        data = List<Map<String, dynamic>>.from(decodedMessage);
      } else {
        data.add(decodedMessage);
      }
      if (!_controller.isClosed) {
        _controller.sink.add(data); // Add updated data to the broadcast stream
      }
      // print("Data updated: $data");
    }, onError: (error) {
      // print("WebSocket error: $error");
      if (!_controller.isClosed) {
        _controller.addError(error); // Add error to the broadcast stream
      }
    }, onDone: () {
      // print("WebSocket connection closed");
      _channel = null; // Reset the channel when done
    });
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }

  Future<List<Map<String, dynamic>>> getRouteInfo(String routeInfoId) async {
    // routes = await rescuerApi.getRouteInfoApi(routeInfoId);
    routes = await rescuerApi.testRoutes();
    return routes;
  }

  void updateRescued(String requestId) async {
    await rescuerApi.updateRescuedApi(requestId);
  }
}
