import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/dialogs.dart';
import '../controllers/profile_controller.dart';
import '../models/response/res_profile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        appBar: CustomAppBar(
          title: 'Profile',
        ),
        backgroundColor: AppColors.bgColor,
        body: controller.isLoading.value
            ? AppLoader.onScreenLoader()
            : pageBody(),
      ),
    );
  }

  Widget pageBody() {
    final profile = controller.profile.value;

    if (profile == null) {
      return Center(
        child: Text(
          'Profile Details Not Available',
          style: AppTextStyle.titleRegular(
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 48,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: profileHeader(profile)),
                  gapH32,
                  organizationSection(profile),
                  const Spacer(),
                  logoutButton(),
                  gapH4,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Profile header
  Widget profileHeader(ResProfile profile) {
    final user = profile.user;
    final role = profile.membership.role;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        profilePhoto(user.avatarUrl),
        gapH20,
        Text(
          user.name.toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyle.titleBold(
            fontSize: 21,
            color: AppColors.textColor,
          ),
        ),
        gapH10,
        profileContact(
          icon: Icons.email_outlined,
          value: user.email,
          iconColor: AppColors.withOpacity(
            AppColors.red,
            0.6,
          ),
        ),
        gapH6,
        profileContact(
          icon: Icons.badge_outlined,
          value: role == 'org_admin'?'ADMIN':'MEMBER',
          iconColor: AppColors.withOpacity(
            AppColors.gold,
            0.6,
          ),
        ),
      ],
    );
  }

  /// Profile photo
  Widget profilePhoto(String? avatarUrl) {
    final hasAvatar =
        avatarUrl != null && avatarUrl.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.green,
          width: 0.7,
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.bgColor,
        child: ClipOval(
          child: hasAvatar
              ? Image.network(
            avatarUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return Image.asset(
                'assets/images/png/person.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            },
          )
              : Image.asset(
            'assets/images/png/person.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Header contact information
  Widget profileContact({
    required IconData icon,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(
          AppColors.dashboardCardBg,
          0.3,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.withOpacity(
            AppColors.primary,
            0.15,
          ),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor,
          ),
          gapW6,
          Text(
            value.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.titleRegular(
              fontSize: 11,
              color: AppColors.withOpacity(
                AppColors.textColor,
                0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Organization section
  Widget organizationSection(ResProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        organizationCard(profile),
      ],
    );
  }

  /// Organization card
  Widget organizationCard(ResProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dashboardCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.withOpacity(
            AppColors.primary,
            0.15,
          ),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.withOpacity(
                AppColors.primary,
                0.12,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.business_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          gapW12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization',
                  style: AppTextStyle.titleRegular(
                    fontSize: 11,
                    color: AppColors.withOpacity(
                      AppColors.textColor,
                      0.5,
                    ),
                  ),
                ),

                gapH4,

                Text(
                  profile.organization.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.titleBold(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.verified_outlined,
            size: 18,
            color: AppColors.green,
          ),
        ],
      ),
    );
  }

  /// Logout button
  Widget logoutButton() {
    return  CustomElevatedButton(
        text: 'Logout',
        onPressed: () async {
         await  Dialogs().logoutConfirm(
            onLogout: () async {
              await controller.logout();
            },
          );
        },
        borderRadius: 18,
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        textColor: AppColors.withOpacity(
          AppColors.red,
          0.6,
        ),
        borderWidth: 0.6,
        borderColor: AppColors.withOpacity(
          AppColors.red,
          0.4,
        ),
    );
  }
}