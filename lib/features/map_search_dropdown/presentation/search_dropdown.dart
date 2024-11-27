import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../map_search/controller/search_controller.dart';

class SearchDropdownWidget extends StatefulWidget {
  const SearchDropdownWidget({
    super.key,
    required this.message,
    required this.controller,
    required this.isTyping,
    required this.onSearch,
    required this.boxType,
  });

  final String message;
  final MapSearchController controller;
  final ValueNotifier<bool> isTyping;
  final Function(LatLng, bool) onSearch;
  final bool boxType;

  @override
  State<SearchDropdownWidget> createState() => _SearchDropdownWidgetState();
}

class _SearchDropdownWidgetState extends State<SearchDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: widget.controller.suggestions,
      builder: (context, suggestions, _) {
        if (!widget.isTyping.value || suggestions.isEmpty) {
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
                  widget.controller.textController.text = suggestions[index];
                  widget.controller.suggestions.value = [];
                  widget.isTyping.value = false;
                  widget.controller
                      .searchPlace(suggestions[index])
                      .then((latLng) {
                    if (latLng != null) {
                      widget.onSearch(latLng, widget.boxType);
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}
