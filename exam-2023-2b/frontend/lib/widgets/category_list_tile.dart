import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

class CategoryListTile extends StatelessWidget {
  final String? category;

  const CategoryListTile({
    Key? key,
    required this.category
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        minVerticalPadding: 7,
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: AppColors.primaryColor.withOpacity(0.25),
        title: Text(
          category ?? "",
          style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}