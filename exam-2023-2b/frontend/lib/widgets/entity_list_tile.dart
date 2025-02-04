import 'package:flutter/material.dart';
import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:logger/logger.dart';

class EntityListTile extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onInc;
  final MyEntity entity;

  const EntityListTile({
    Key? key,
    required this.entity,
    this.onEdit,
    this.onDelete,
    this.onInc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(entity.toJson());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        minVerticalPadding: 7,
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: AppColors.primaryColor.withOpacity(0.25),
        title: Text(
          entity.name ?? "",
          style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold
          ),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (onInc != null)
            IconButton(
              onPressed: onInc,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          if (onDelete != null && !Repo.useLocal)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          const Icon(
            Icons.info_outline,
            color: Colors.white70,
          ),
        ]),
        onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(entity.name ?? ""),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entity.description ?? ""),
                Text(entity.intensity ?? "")
              ],
            ),
          )
        ),
      ),
    );
  }
}