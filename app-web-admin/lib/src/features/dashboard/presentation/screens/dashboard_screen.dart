import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../auth/application/providers/auth_providers.dart';
import '../widgets/sidebar_navigation.dart';

class DashboardScreen extends ConsumerWidget {
  final Widget child;

  const DashboardScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(context),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<void>(
                tooltip: "Account",
                onSelected: (_) {
                  ref.read(authNotifierProvider.notifier).signOut();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: null,
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.email,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.role.name),
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: null,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Log Out'),
                    ),
                  ),
                ],
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.email.isNotEmpty ? user.email[0].toUpperCase() : 'A',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Row(
        children: [
          const SidebarNavigation(),
          const VerticalDivider(width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.userManagement.path)) {
      return 'User & Team Management';
    } else if (location.startsWith(AppRoutes.reports.path)) {
      return 'Reports';
    } else if (location.startsWith(AppRoutes.settings.path)) {
      return 'Tenant Settings';
    }
    return 'Dashboard';
  }
}