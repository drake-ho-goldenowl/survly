import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/theme/colors.dart';

class AppAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const AppAppBarWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: title != null ? Text(title!) : const SizedBox(),
      leading: leading ??
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              context.pop();
            },
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
