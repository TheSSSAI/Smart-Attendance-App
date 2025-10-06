import 'package:flutter/material.dart';
import 'package:shared_ui_components/shared_ui_components.dart';

void main() {
  runApp(const ComponentShowcaseApp());
}

class ComponentShowcaseApp extends StatelessWidget {
  const ComponentShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared UI Components Showcase',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const ShowcaseHomePage(),
    );
  }
}

class ShowcaseHomePage extends StatelessWidget {
  const ShowcaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final components = [
      _ShowcaseItem(
        title: 'Atomic: Primary Buttons',
        builder: (_) => const _ButtonShowcase(),
      ),
      _ShowcaseItem(
        title: 'Atomic: Text Input Fields',
        builder: (_) => const _TextFieldShowcase(),
      ),
      _ShowcaseItem(
        title: 'Atomic: Status Badges',
        builder: (_) => const _StatusBadgeShowcase(),
      ),
      _ShowcaseItem(
        title: 'Atomic: Alert Banners',
        builder: (_) => const _AlertBannerShowcase(),
      ),
      _ShowcaseItem(
        title: 'Molecular: Confirmation Dialogs',
        builder: (_) => const _DialogShowcase(),
      ),
      _ShowcaseItem(
        title: 'Molecular: Attendance List Item',
        builder: (_) => const _ListItemShowcase(),
      ),
      _ShowcaseItem(
        title: 'Organism: Authentication Form',
        builder: (_) => const _AuthFormShowcase(),
      ),
      _ShowcaseItem(
        title: 'Organism: Calendar View',
        builder: (_) => const _CalendarShowcase(),
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Component Showcase'),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.medium),
        itemCount: components.length,
        itemBuilder: (context, index) {
          final item = components[index];
          return ListTile(
            title: Text(item.title),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShowcaseDetailPage(
                    title: item.title,
                    child: item.builder(context),
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class ShowcaseDetailPage extends StatelessWidget {
  final String title;
  final Widget child;

  const ShowcaseDetailPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: child,
    );
  }
}

class _ShowcaseItem {
  final String title;
  final WidgetBuilder builder;

  _ShowcaseItem({required this.title, required this.builder});
}

// --- Showcase Pages ---

class _ButtonShowcase extends StatefulWidget {
  const _ButtonShowcase();

  @override
  State<_ButtonShowcase> createState() => _ButtonShowcaseState();
}

class _ButtonShowcaseState extends State<_ButtonShowcase> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Default State'),
          const SizedBox(height: AppSpacing.small),
          PrimaryButton(
            label: 'Enabled Button',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Button Pressed!')),
              );
            },
          ),
          const SizedBox(height: AppSpacing.large),
          const Text('Loading State'),
          const SizedBox(height: AppSpacing.small),
          PrimaryButton(
            label: 'Loading Button',
            isLoading: _isLoading,
            onPressed: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
          ),
          const SizedBox(height: AppSpacing.large),
          const Text('Disabled State'),
          const SizedBox(height: AppSpacing.small),
          const PrimaryButton(
            label: 'Disabled Button',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class _TextFieldShowcase extends StatelessWidget {
  const _TextFieldShowcase();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.large),
        children: const [
          Text('Default State'),
          SizedBox(height: AppSpacing.small),
          TextInputField(
            labelText: 'Email Address',
            hintText: 'user@example.com',
          ),
          SizedBox(height: AppSpacing.large),
          Text('Error State'),
          SizedBox(height: AppSpacing.small),
          TextInputField(
            labelText: 'Username',
            hintText: 'Enter your username',
            errorText: 'Username must be at least 6 characters.',
          ),
          SizedBox(height: AppSpacing.large),
          Text('Password State'),
          SizedBox(height: AppSpacing.small),
          TextInputField(
            labelText: 'Password',
            hintText: 'Enter your password',
            isPassword: true,
          ),
          SizedBox(height: AppSpacing.large),
          Text('Disabled State'),
          SizedBox(height: AppSpacing.small),
          TextInputField(
            labelText: 'Read Only',
            hintText: 'This field cannot be edited',
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _StatusBadgeShowcase extends StatelessWidget {
  const _StatusBadgeShowcase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Wrap(
        spacing: AppSpacing.medium,
        runSpacing: AppSpacing.medium,
        children: const [
          StatusBadge(status: 'Pending', type: BadgeType.pending),
          StatusBadge(status: 'Approved', type: BadgeType.approved),
          StatusBadge(status: 'Rejected', type: BadgeType.rejected),
          StatusBadge(status: 'Offline', type: BadgeType.info),
          StatusBadge(status: 'Auto Check-Out', type: BadgeType.info),
        ],
      ),
    );
  }
}

class _AlertBannerShowcase extends StatelessWidget {
  const _AlertBannerShowcase();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.large),
      children: [
        const Text('Informational'),
        const SizedBox(height: AppSpacing.small),
        const AlertBanner(
          type: AlertType.info,
          message: 'This is an informational message.',
        ),
        const SizedBox(height: AppSpacing.large),
        const Text('Success'),
        const SizedBox(height: AppSpacing.small),
        const AlertBanner(
          type: AlertType.success,
          message: 'Your profile has been updated successfully.',
        ),
        const SizedBox(height: AppSpacing.large),
        const Text('Warning'),
        const SizedBox(height: AppSpacing.small),
        AlertBanner(
          type: AlertType.warning,
          message: 'Your session will expire in 5 minutes.',
          action: TextButton(onPressed: () {}, child: const Text('RENEW')),
        ),
        const SizedBox(height: AppSpacing.large),
        const Text('Error'),
        const SizedBox(height: AppSpacing.small),
        AlertBanner(
          type: AlertType.error,
          message: 'Failed to sync offline data.',
          action: TextButton(onPressed: () {}, child: const Text('RETRY')),
        ),
      ],
    );
  }
}

class _DialogShowcase extends StatelessWidget {
  const _DialogShowcase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(
            label: 'Show Standard Dialog',
            onPressed: () async {
              final result = await showConfirmationDialog(
                context: context,
                title: 'Confirm Action',
                content: 'Are you sure you want to proceed?',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dialog returned: $result')),
              );
            },
          ),
          const SizedBox(height: AppSpacing.medium),
          PrimaryButton(
            label: 'Show Destructive Dialog',
            onPressed: () async {
              final result = await showConfirmationDialog(
                context: context,
                title: 'Delete Team',
                content:
                    'This will permanently delete the team. This action cannot be undone.',
                confirmText: 'Delete',
                isDestructive: true,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dialog returned: $result')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ListItemShowcase extends StatelessWidget {
  const _ListItemShowcase();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        const Text('Supervisor View'),
        const SizedBox(height: AppSpacing.small),
        AttendanceListItem(
          userName: 'John Doe',
          checkInTime: '09:05 AM',
          checkOutTime: '05:02 PM',
          flags: const [
            StatusBadge(status: 'Pending', type: BadgeType.pending),
          ],
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.medium),
        AttendanceListItem(
          userName: 'Jane Smith',
          checkInTime: '08:55 AM',
          checkOutTime: '04:30 PM',
          flags: const [
            StatusBadge(status: 'Pending', type: BadgeType.pending),
            StatusBadge(status: 'Offline', type: BadgeType.info),
          ],
          onTap: () {},
        ),
        const Divider(height: AppSpacing.large * 2),
        const Text('Subordinate View'),
        const SizedBox(height: AppSpacing.small),
        AttendanceListItem.subordinate(
          date: 'May 24, 2024',
          checkInTime: '09:00 AM',
          checkOutTime: '05:00 PM',
          flags: const [
            StatusBadge(status: 'Approved', type: BadgeType.approved),
          ],
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.medium),
        AttendanceListItem.subordinate(
          date: 'May 23, 2024',
          checkInTime: '09:15 AM',
          checkOutTime: '05:05 PM',
          flags: const [
            StatusBadge(status: 'Rejected', type: BadgeType.rejected),
          ],
          onTap: () {},
        ),
      ],
    );
  }
}

class _AuthFormShowcase extends StatelessWidget {
  const _AuthFormShowcase();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: AuthenticationForm(
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Authentication successful!')),
            );
          },
        ),
      ),
    );
  }
}

class _CalendarShowcase extends StatelessWidget {
  const _CalendarShowcase();

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      events: {
        DateTime.now().toUtc().subtract(const Duration(days: 2)): [
          const {'id': '1', 'title': 'Morning Standup'},
          const {'id': '2', 'title': 'Client Meeting'},
        ],
        DateTime.now().toUtc(): [
          const {'id': '3', 'title': 'Project Deadline'},
        ],
      },
      onDateSelected: (date) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Date selected: ${date.toIso8601String()}')),
        );
      },
    );
  }
}