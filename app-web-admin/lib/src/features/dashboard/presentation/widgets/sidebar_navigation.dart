import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_web_admin/src/features/auth/application/providers/auth_providers.dart';
import 'package:app_web_admin/src/config/router/app_router.dart';

class SidebarNavigation extends ConsumerWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final currentPath = GoRouter.of(context).location;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Admin Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            path: AppRoutes.dashboard,
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.people_alt_outlined,
            title: 'User Management',
            path: AppRoutes.userManagement,
            currentPath: currentPath,
          ),
          // Assuming team management is part of user management or its own route
          _buildNavItem(
            context,
            icon: Icons.group_work_outlined,
            title: 'Team Management',
            path: AppRoutes.teamManagement, // Assumed route
            currentPath: currentPath,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Reports', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildNavItem(
            context,
            icon: Icons.summarize_outlined,
            title: 'Summary Reports',
            path: AppRoutes.summaryReport,
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.report_problem_outlined,
            title: 'Exception Reports',
            path: AppRoutes.exceptionReport,
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.history_edu_outlined,
            title: 'Audit Log',
            path: AppRoutes.auditLog,
            currentPath: currentPath,
          ),
          const Divider(),
          _buildNavItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Tenant Settings',
            path: AppRoutes.tenantSettings,
            currentPath: currentPath,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authNotifier.signOut();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String path,
    required String currentPath,
  }) {
    final bool isSelected = currentPath.startsWith(path);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () {
        context.go(path);
      },
    );
  }
}