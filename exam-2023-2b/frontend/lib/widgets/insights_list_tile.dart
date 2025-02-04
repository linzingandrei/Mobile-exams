import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

class InsightsListTile extends StatelessWidget {
  final Map<String, dynamic> insight;

  const InsightsListTile({
    Key? key,
    required this.insight
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
          '${insight["category"]?.toString() ?? ""} ${insight["averageRating"]?.toString() ?? ""}',
          style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}