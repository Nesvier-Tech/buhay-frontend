import 'package:flutter/material.dart';
import '../../map_search/controller/search_controller.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget(
      {super.key,
      required this.message,
      required this.controller,
      required this.isTyping});

  final String message;
  final MapSearchController controller;
  final ValueNotifier<bool> isTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      color: Colors.white,
      child: TextField(
        controller: controller.textController,
        decoration: InputDecoration(
          hintText: message,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              controller.searchPlace(controller.textController.text);
            },
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        onSubmitted: (value) {
          controller.searchPlace(value);
          isTyping.value = false;
        },
        onChanged: (value) {
          isTyping.value = value.isNotEmpty;
          controller.getSuggestions(value);
        },
      ),
    );
  }
}
