import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_loader.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Obx(
        () => SafeArea(
          child: controller.isDataLoaded.value
              ? Scaffold(
                  appBar: dashboardAppBar(),
                  backgroundColor: AppColors.bgColor,
                  body: RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.white,
                    onRefresh: () async => await controller.getDashboardData(),
                    child:pageBody()),
                )
              : appLoader(),
        ),
      ),
    );
  }

  Widget pageBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          welcomeSection(),
          gapH24,
          statsSection(),
          gapH28,
          dashboardGrid(),
          gapH20,
          Align(alignment: Alignment.center, child: refreshTime()),
        ],
      ),
    );
  }

  /// Dashboard welcome section
  Widget welcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${controller.userName.value} 👋',
          style: AppTextStyle.titleBold(
            fontSize: 22,
            color: AppColors.textColor,
          ),
        ),
        gapH6,
        Text(
          'Here is your TaskFlow overview',
          style: AppTextStyle.titleRegular(
            fontSize: 13,
            color: AppColors.withOpacity(AppColors.textColor, 0.5),
          ),
        ),
      ],
    );
  }

  /// Dashboard statistics
  Widget statsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statCard(
          title: 'Projects',
          count: controller.totalProjects,
          stats: [
            ('Active', controller.activeProjects),
            ('Completed', controller.completedProjects),
          ],
        ),
        gapH12,
        statCard(
          title: 'Tasks',
          count: controller.totalTasks,
          stats: [
            ('To Do', controller.todoTasks),
            ('Progress', controller.inProgressTasks),
            ('Review', controller.reviewTasks),
            ('Done', controller.completedTasks),
          ],
        ),
      ],
    );
  }

  /// Dashboard statistic card
  Widget statCard({
    required String title,
    required int count,
    required List<(String, int)> stats,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.darkCardColor, 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.withOpacity(AppColors.primary, 0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count.toString(),
                style: AppTextStyle.titleBold(
                  fontSize: 34,
                  color: AppColors.green,
                ),
              ),
              gapW12,
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  title,
                  style: AppTextStyle.titleBold(
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
          gapH12,
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: stats.map((stat) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(AppColors.textColor, 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.$1,
                      style: AppTextStyle.titleRegular(
                        fontSize: 10,
                        color: AppColors.withOpacity(AppColors.textColor, 0.55),
                      ),
                    ),
                    gapW6,
                    Text(
                      stat.$2.toString(),
                      style: AppTextStyle.titleBold(
                        fontSize: 10,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Clickable dashboard options
  Widget dashboardGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: AppTextStyle.titleBold(
            fontSize: 16,
            color: AppColors.withOpacity(AppColors.textColor, 0.7),
          ),
        ),
        gapH12,
        Row(
          children: [
            Expanded(
              child: dashboardOption(
                title: 'Projects',
                subtitle: 'Manage your projects',
                iconString: '📈',
                onTap: () {
                  Get.toNamed(AppRoutes().projectView);
                },
              ),
            ),
            gapW12,
            Expanded(
              child: dashboardOption(
                title: 'Tasks',
                subtitle: 'Manage your tasks',
                iconString: '🎯',
                onTap: () {
                  Get.toNamed(AppRoutes().taskView);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Clickable dashboard option
  Widget dashboardOption({
    required String title,
    required String subtitle,
    required String iconString,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.dashboardCardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.withOpacity(AppColors.primary, 0.2),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.withOpacity(AppColors.primary, 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                iconString,
                style: AppTextStyle.titleRegular(fontSize: 22),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyle.titleBold(
                fontSize: 15,
                color: AppColors.textColor,
              ),
            ),
            gapH4,
            Text(
              subtitle,
              style: AppTextStyle.titleRegular(
                fontSize: 11,
                color: AppColors.withOpacity(AppColors.textColor, 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dashboard app bar
  PreferredSize dashboardAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.withOpacity(AppColors.inactiveBorder, 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: AppBar(
          backgroundColor: AppColors.bgColor,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/png/task_flow_logo_horizontal.png',
                  height: 46,
              errorBuilder: (_, _, _) => Icon(
                Icons.task,
                size: 40,
                color: AppColors.primary,
              ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes().profileView);
                  },
                  child: userProfilePhoto(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// User profile photo
  Widget userProfilePhoto() {
    final profilePhoto = controller.userAvatarUrl.value;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.green, width: 0.4),
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.bgColor,
        child: ClipOval(
          child: profilePhoto.isNotEmpty
              ? Image.network(
                  profilePhoto,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Image.asset(
                    'assets/images/png/person.png',
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/png/person.png',
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget refreshTime() {
    final refreshTime = controller.lastRefreshTime;

    if (refreshTime == null) return const SizedBox();

    final diff = DateTime.now().difference(refreshTime);

    final text = diff.inMinutes < 1
        ? 'Updated just now'
        : diff.inMinutes < 60
        ? 'Updated ${diff.inMinutes} min ago'
        : diff.inHours < 24
        ? 'Updated ${diff.inHours} hr ago'
        : 'Updated ${diff.inDays} day ago';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: AppTextStyle.titleRegular(
            fontSize: 12,
            color: AppColors.hintColor,
          ),
        ),
      ],
    );
  }

  Widget appLoader() {
    return Container(
      color: AppColors.bgColor,
      child: AppLoader.onScreenLoader(),
    );
  }
}
