import 'package:flutter/material.dart';

class FilterBottomSheet {
  static Future<String?> showFilterBottomSheet({
    required BuildContext context,
    required Function(String) onSelectFilter,
    required String selectedFilter,
  }) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Semua'),
                onTap: () {
                  selectedFilter = 'Semua';
                  onSelectFilter(selectedFilter);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sudah diaudit'),
                onTap: () {
                  selectedFilter = 'Sudah diaudit';
                  onSelectFilter(selectedFilter);
                  Navigator.pop(context);
                },
                // Add more filter options as needed
              ),
              ListTile(
                title: const Text('Belum diaudit'),
                onTap: () {
                  selectedFilter = 'Belum diaudit';
                  onSelectFilter(selectedFilter);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedFilter;
  }
}
