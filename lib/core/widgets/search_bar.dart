import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String hiddenText;
  final Function(String) search;
  final Function(String) onChange;
  const SearchBox({
    super.key,
    required this.hiddenText,
    required this.search,

    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              onChanged: onChange,
              autofocus: false,
              onSubmitted: search,
              decoration: InputDecoration(
                hintText: hiddenText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ],
      
    );
  }
}
