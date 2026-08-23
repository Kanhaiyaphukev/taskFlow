import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_drpodown.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/task_controller.dart';
import '../models/response/res_task.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: 'Tasks',
          actions: [
            if (controller.isOrgAdmin.value) ...[createTaskButton(), gapW8],
          ],
        ),
        backgroundColor: AppColors.bgColor,
        body: controller.isLoading.value && !controller.isDataLoaded.value
            ? AppLoader.onScreenLoader()
            : taskBody(),
      ),
    );
  }

  Widget taskBody() {
    if (controller.filteredTasks.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refreshTasks,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.35),
            Center(
              child: Text(
                'No tasks found',
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
      onRefresh: controller.refreshTasks,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.filteredTasks.length,
        separatorBuilder: (_, _) => gapH12,
        itemBuilder: (context, index) {
          return taskCard(controller.filteredTasks[index]);
        },
      ),
    );
  }

  Widget taskCard(ResTask task) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.toNamed(AppRoutes().taskDetailsView, arguments: task.id);
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
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.titleBold(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                gapW8,
                status(task.status),
              ],
            ),
            gapH8,
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.titleRegular(
                fontSize: 12,
                color: AppColors.withOpacity(AppColors.textColor, 0.6),
              ),
            ),
            gapH12,
            Row(
              children: [
                priority(task.priority),
                const Spacer(),
                if (controller.getAssigneeName(task.assigneeId) != null)
                  Text(
                    controller.getAssigneeName(task.assigneeId)!,
                    style: AppTextStyle.titleRegular(
                      fontSize: 11,
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

  Widget status(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.green, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value.toUpperCase(),
        style: AppTextStyle.titleBold(fontSize: 10, color: AppColors.green),
      ),
    );
  }

  Widget priority(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.primary, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value.toUpperCase(),
        style: AppTextStyle.titleBold(fontSize: 10, color: AppColors.primary),
      ),
    );
  }

  Widget createTaskButton() {
    return IconButton(
      onPressed: () {
        controller.prepareCreateTask();

        Get.bottomSheet(
          createTaskSheet(),
          isScrollControlled: true,
          backgroundColor: AppColors.bgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        );
      },
      icon: Icon(Icons.add_rounded, size: 26, color: AppColors.textColor),
      tooltip: 'Create Task',
    );
  }

  Widget createTaskSheet() {
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
              ? SizedBox(height: 350, child: AppLoader.onScreenLoader())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Create Task',
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
                      formLabel('Project'),
                      gapH8,
                      _projectDropdown(),
                      gapH20,
                      formLabel('Task Title'),
                      gapH8,
                      CustomTextField(
                        controller: controller.titleController,
                        hintText: 'Enter task title',
                        textInputAction: TextInputAction.next,
                        isMandatory: true,
                      ),
                      gapH20,
                      formLabel('Description'),
                      gapH8,
                      CustomTextField(
                        controller: controller.descriptionController,
                        hintText: 'Enter task description',
                        textInputAction: TextInputAction.done,
                        isMultiline: true,
                        isMandatory: true,
                      ),
                      gapH20,
                      formLabel('Due Date'),
                      gapH8,
                      CustomTextField(
                        controller: controller.dueDateController,
                        hintText: 'Select due date',
                        isDateField: true,
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: AppColors.secondary,
                          size: 22,
                        ),
                        textInputAction: TextInputAction.done,
                        isMandatory: true,
                      ),
                      gapH20,
                      formLabel('Status'),
                      gapH8,
                      _statusDropdown(),
                      gapH20,
                      formLabel('Priority'),
                      gapH8,
                      _priorityDropdown(),
                      gapH20,
                      formLabel('Assignee'),
                      gapH8,
                      _assigneeDropdown(),
                      gapH28,
                      CustomElevatedButton(
                        text: 'Create Task',
                        onPressed: () {
                          controller.createTask();
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

  Widget _projectDropdown() {
    return CustomDropdown(
      hint: 'Select project',
      items: controller.projects.map((project) => project.name).toList(),
      selectedValue: controller.selectedProjectName,
      onChanged: (value) {
        final project = controller.projects.firstWhere(
          (project) => project.name == value,
        );

        controller.selectedProjectName.value = value;
        controller.selectedProjectId.value = project.id;
      },
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
    );
  }

  Widget _statusDropdown() {
    return CustomDropdown(
      hint: 'Select status',
      items: const ['todo', 'in_progress', 'completed'],
      selectedValue: controller.selectedStatus,
      onChanged: (value) {
        controller.selectedStatus.value = value;
      },
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
    );
  }

  Widget _priorityDropdown() {
    return CustomDropdown(
      hint: 'Select priority',
      items: const ['low', 'medium', 'high'],
      selectedValue: controller.selectedPriority,
      onChanged: (value) {
        controller.selectedPriority.value = value;
      },
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
    );
  }

  Widget _assigneeDropdown() {
    return CustomDropdown(
      hint: 'Select assignee',
      items: controller.users.map((user) => user.name).toList(),
      selectedValue: controller.selectedAssigneeName,
      onChanged: (value) {
        final user = controller.users.firstWhere((user) => user.name == value);

        controller.selectedAssigneeName.value = value;
        controller.selectedAssigneeId.value = user.id;
      },
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
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
}
