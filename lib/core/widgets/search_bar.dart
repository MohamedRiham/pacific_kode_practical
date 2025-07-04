import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final double height;
  final String hiddenText;
  final Function(String) search;
  final Function(String) onChange;
  const SearchBox({
    super.key,
    required this.height,
    required this.hiddenText,
    required this.search,

    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
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
                hintStyle: TextStyle(color: Colors.black),
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
      ),
    );
  }
}
