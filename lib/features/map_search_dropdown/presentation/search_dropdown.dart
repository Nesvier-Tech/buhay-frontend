import 'package:flutter/material.dart';
import '../../map_search/controller/search_controller.dart';

class SearchDropdownWidget extends StatelessWidget {
  const SearchDropdownWidget({
    super.key,
    required this.message,
    required this.controller,
    required this.isTyping,
  });

  final String message;
  final MapSearchController controller;
  final ValueNotifier<bool> isTyping;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: controller.suggestions,
      builder: (context, suggestions, _) {
        if (!isTyping.value || suggestions.isEmpty) {
          return Container();
        }

        return SizedBox(
          height: suggestions.isEmpty
              ? 0
              : (suggestions.length * 60.0).clamp(0, 300),
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(suggestions[index],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16.0)),
                  ),
                ),
                onTap: () {
                  controller.textController.text = suggestions[index];
                  controller.suggestions.value = [];
                  isTyping.value = false;
                  controller.searchPlace(suggestions[index]);
                },
              );
            },
          ),
        );
      },
    );
  }
}
