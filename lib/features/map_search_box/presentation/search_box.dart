import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../map_search/controller/search_controller.dart';

class SearchBoxWidget extends StatefulWidget {
  const SearchBoxWidget({
    super.key,
    required this.message,
    required this.controller,
    required this.isTyping,
    required this.onSearch,
    required this.boxType,
    required this.focusNode,
  });

  final String message;
  final MapSearchController controller;
  final ValueNotifier<bool> isTyping;
  final Function(LatLng, bool) onSearch;
  final bool boxType;
  final FocusNode focusNode;

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        widget.isTyping.value = false;
        widget.controller.suggestions.value = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      color: Colors.white,
      child: TextField(
        controller: widget.controller.textController,
        decoration: InputDecoration(
          hintText: widget.message,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              widget.controller
                  .searchPlace(widget.controller.textController.text)
                  .then((latLng) {
                if (latLng != null) {
                  widget.onSearch(latLng, widget.boxType);
                }
              });
              widget.isTyping.value = false;
            },
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        onSubmitted: (value) async {
          final latLng = await widget.controller.searchPlace(value);
          if (latLng != null) {
            widget.onSearch(latLng, widget.boxType);
          }
          widget.isTyping.value = false;
        },
        onChanged: (value) {
          widget.isTyping.value = value.isNotEmpty;
          widget.controller.getSuggestions(value);
        },
        focusNode: widget.focusNode,
      ),
    );
  }
}
