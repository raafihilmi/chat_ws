import 'dart:async';

import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const MySearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _showError = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showError = false;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        widget.onSearch('');
      } else if (query.length < 3) {
        setState(() {
          _showError = true;
        });
      } else {
        widget.onSearch(query);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showError = false;
    });
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          if (_showError)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Masukkan lebih dari 3 huruf',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}