import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/project_controller.dart';
import '../models/response/res_project.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: 'Projects',
          actions: [
            if (controller.isOrgAdmin.value) ...[createProjectButton(), gapW8],
          ],
        ),
        backgroundColor: AppColors.bgColor,
        body: controller.isLoading.value && !controller.isDataLoaded.value
            ? AppLoader.onScreenLoader()
            : projectBody(),
      ),
    );
  }

  Widget projectBody() {
    if (controller.projects.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refreshProjects,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.35),
            Center(
              child: Text(
                'No projects found',
                style: AppTextStyle.titleRegular(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.refreshProjects,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.projects.length,
        separatorBuilder: (_, _) => gapH12,
        itemBuilder: (context, index) {
          return projectCard(controller.projects[index]);
        },
      ),
    );
  }

  Widget projectCard(ResProject project) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.toNamed(AppRoutes().projectDetailsView, arguments: project.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dashboardCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.withOpacity(AppColors.primary, 0.15),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.titleBold(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                gapW8,
                projectStatus(project.status),
              ],
            ),
            gapH8,
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.titleRegular(
                fontSize: 12,
                color: AppColors.withOpacity(AppColors.textColor, 0.6),
              ),
            ),
            gapH14,
            Row(
              children: [
                Icon(Icons.task_outlined, size: 16, color: AppColors.primary),
                gapW6,
                Text(
                  '${project.taskCount} Tasks',
                  style: AppTextStyle.titleBold(
                    fontSize: 12,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget projectStatus(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.green, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.titleBold(fontSize: 10, color: AppColors.green),
      ),
    );
  }

  Widget createProjectButton() {
    return IconButton(
      onPressed: () {
        controller.clearForm();
        Get.bottomSheet(
          createProjectSheet(),
          isScrollControlled: true,
          backgroundColor: AppColors.bgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        );
      },
      icon: Icon(Icons.add_rounded, size: 26, color: AppColors.textColor),
      tooltip: 'Create Project',
    );
  }

  Widget createProjectSheet() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
        ),
        child: Obx(
          () => controller.isFormLoading.value
              ? SizedBox(height: 250, child: AppLoader.onScreenLoader())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Create Project',
                              style: AppTextStyle.titleBold(
                                fontSize: 18,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: Get.back,
                            icon: Icon(Icons.close, color: AppColors.textColor),
                          ),
                        ],
                      ),
                      gapH20,
                      _label('Project Name'),
                      gapH8,
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: 'Enter project name',
                        textInputAction: TextInputAction.next,
                        isMandatory: true,
                      ),
                      gapH20,
                      _label('Description'),
                      gapH8,
                      CustomTextField(
                        controller: controller.descriptionController,
                        hintText: 'Enter project description',
                        textInputAction: TextInputAction.done,
                        isMultiline: true,
                        isMandatory: true,
                      ),
                      gapH28,
                      CustomElevatedButton(
                        text: 'Create Project',
                        onPressed: () {
                          controller.createProject();
                        },
                        borderRadius: 16,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.bgColor,
                      ),
                      gapH8,
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: AppTextStyle.titleBold(
              fontSize: 13,
              color: AppColors.textColor,
            ),
          ),
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.withOpacity(
                AppColors.red,
                0.7,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
