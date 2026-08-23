import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/project_controller.dart';
import '../models/response/res_project.dart';

class ProjectDetailsView extends GetView<ProjectController> {
  const ProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initializeProjectDetails();

    final projectId = Get.arguments as String?;

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(title: 'Project Details'),
        backgroundColor: AppColors.bgColor,
        body: pageBody(projectId),
      ),
    );
  }

  Widget pageBody(String? projectId) {
    if (projectId == null || projectId.isEmpty) {
      return notFound();
    }

    if (controller.isDetailsLoading.value) {
      return AppLoader.onScreenLoader();
    }

    final project = controller.selectedProject.value;

    if (project == null) {
      return notFound();
    }

    return projectBody(project);
  }

  Widget projectBody(ResProject project) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          projectHeader(project),

          gapH24,

          Text(
            'Tasks',
            style: AppTextStyle.titleBold(
              fontSize: 17,
              color: AppColors.textColor,
            ),
          ),
          gapH12,
          taskSummary(project),
          gapH28,
          editButton(project),
          gapH12,
          deleteButton(project),
          gapH20,
        ],
      ),
    );
  }

  Widget projectHeader(ResProject project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.dashboardCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.withOpacity(AppColors.primary, 0.15),
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
                  style: AppTextStyle.titleBold(
                    fontSize: 21,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              status(project.status),
            ],
          ),
          gapH12,
          Text(
            project.description,
            style: AppTextStyle.titleRegular(
              fontSize: 13,
              color: AppColors.withOpacity(AppColors.textColor, 0.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskSummary(ResProject project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dashboardCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.withOpacity(AppColors.primary, 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              summaryItem('Tasks', project.taskCount, fontSize: 15),
              summaryItem(
                'Status',
                project.status.toUpperCase(),
                color: AppColors.green,
                fontSize: 14,
              ),
            ],
          ),
          gapH14,
          Center(
            child: CustomTextButton(
              text: 'View Tasks',
              onPressed: () {
                Get.toNamed(AppRoutes().taskView, arguments: project.id);
              },
              textColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryItem(
    String label,
    dynamic value, {
    Color? color,
    double? fontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.titleRegular(
            fontSize: 11,
            color: AppColors.withOpacity(AppColors.textColor, 0.5),
          ),
        ),
        gapH4,
        Text(
          value.toString(),
          style: AppTextStyle.titleBold(
            fontSize: fontSize ?? 15,
            color: color ?? AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget editButton(ResProject project) {
    if (!controller.isOrgAdmin.value) {
      return const SizedBox.shrink();
    }

    return CustomElevatedButton(
      text: 'Edit Project',
      onPressed: () {
        showEditProjectSheet(project);
      },
      borderRadius: 16,
      backgroundColor: AppColors.primary,
      textColor: AppColors.bgColor,
    );
  }

  Widget deleteButton(ResProject project) {
    if (!controller.isOrgAdmin.value) {
      return const SizedBox.shrink();
    }

    return CustomElevatedButton(
      text: 'Delete Project',
      onPressed: () {
        controller.confirmDeleteProject(project.id);
      },
      borderRadius: 16,
      backgroundColor: AppColors.transparent,
      foregroundColor: AppColors.transparent,
      textColor: AppColors.withOpacity(AppColors.red, 0.7),
      borderWidth: 0.6,
      borderColor: AppColors.withOpacity(AppColors.red, 0.4),
    );
  }

  void showEditProjectSheet(ResProject project) {
    controller.nameController.text = project.name;
    controller.descriptionController.text = project.description;

    Get.bottomSheet(
      SafeArea(
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
                                'Update Project',
                                style: AppTextStyle.titleBold(
                                  fontSize: 18,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: Get.back,
                              icon: Icon(
                                Icons.close,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                        gapH20,
                        formLabel('Project Name'),
                        gapH8,
                        CustomTextField(
                          controller: controller.nameController,
                          hintText: 'Enter project name',
                          textInputAction: TextInputAction.next,
                          isMandatory: true,
                        ),
                        gapH20,
                        formLabel('Description'),
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
                          text: 'Update Project',
                          onPressed: () {
                            controller.updateProject(project.id);
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
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  Widget formLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: AppTextStyle.titleBold(
              fontSize: 12,
              color: AppColors.textColor,
            ),
          ),
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.withOpacity(AppColors.red, 0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget status(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.green, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.titleBold(fontSize: 11, color: AppColors.green),
      ),
    );
  }

  Widget notFound() {
    return Center(
      child: Text(
        'Project not found',
        style: AppTextStyle.titleRegular(
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
