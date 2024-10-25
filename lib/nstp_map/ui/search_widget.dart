import 'package:flutter/material.dart';
import '../controller/search_controller.dart' as local;

class SearchWidget extends StatelessWidget {
  final local.SearchController controller;
  final Function(String) onSearch;
  final double width;

  const SearchWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller.textController,
        decoration: InputDecoration(
          hintText: 'Search for a place',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => onSearch(controller.text),
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
  }
}
