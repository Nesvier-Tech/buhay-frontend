import 'package:flutter/material.dart';
import '../controller/search_controller.dart' as local;

class SearchWidget extends StatelessWidget {
  final local.SearchController controller;
  final Function(String) onSearch;
  final double width;

  SearchWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.width,
  });

  // Change isTyping to a ValueNotifier
  final ValueNotifier<bool> isTyping =
      ValueNotifier(false); // Use ValueNotifier

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          TextField(
            controller: controller.textController,
            decoration: InputDecoration(
              hintText: 'Search for a place',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => onSearch(controller.text),
              ),
            ),
            onSubmitted: (value) {
              onSearch(value);
              isTyping.value = false;
            },
            onChanged: (value) {
              isTyping.value = value.isNotEmpty;
              controller.fetchSuggestions(value);
            },
          ),
          // Dropdown for suggestions
          ValueListenableBuilder<List<String>>(
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
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            suggestions[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      onTap: () {
                        // Handle selection
                        controller.textController.text = suggestions[index];
                        onSearch(suggestions[index]);
                        isTyping.value = false;
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
