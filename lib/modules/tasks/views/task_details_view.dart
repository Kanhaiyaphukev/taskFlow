import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_drpodown.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/task_controller.dart';
import '../models/response/res_task.dart';

class TaskDetailsView extends GetView<TaskController> {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CustomAppBar(title: 'Task Details'),
        body: controller.isDetailsLoading.value
            ? AppLoader.onScreenLoader()
            : controller.selectedTask.value == null
            ? notFound()
            : _body(controller.selectedTask.value!),
      ),
    );
  }

  Widget notFound() {
    return Center(
      child: Text(
        'Task not found',
        style: AppTextStyle.titleRegular(
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _body(ResTask task) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _taskHeader(task),
          gapH20,
          _taskSummary(task),
          if (controller.isOrgAdmin.value) ...[
            gapH28,
            _editButton(task),
            gapH12,
            _deleteButton(task),
          ],
          gapH20,
        ],
      ),
    );
  }

  Widget _taskHeader(ResTask task) {
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
          Text(
            task.title,
            style: AppTextStyle.titleBold(
              fontSize: 20,
              color: AppColors.textColor,
            ),
          ),
          gapH12,
          Text(
            task.description,
            style: AppTextStyle.titleRegular(
              fontSize: 13,
              color: AppColors.withOpacity(AppColors.textColor, 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskSummary(ResTask task) {
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
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Status',
                  task.status.toUpperCase(),
                  AppColors.green,
                ),
              ),
              Expanded(
                child: _summaryItem(
                  'Priority',
                  task.priority.toUpperCase(),
                  AppColors.primary,
                ),
              ),
            ],
          ),
          gapH16,
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Due Date',
                  task.dueDate,
                  AppColors.secondary,
                ),
              ),
              Expanded(
                child: _summaryItem(
                  'Assignee',
                  controller.getAssigneeName(task.assigneeId) ?? 'Unassigned',
                  AppColors.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.titleRegular(
            fontSize: 11,
            color: AppColors.withOpacity(AppColors.textColor, 0.6),
          ),
        ),
        gapH4,
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.titleBold(fontSize: 13, color: color),
        ),
      ],
    );
  }

  Widget _editButton(ResTask task) {
    return CustomElevatedButton(
      text: 'Edit Task',
      onPressed: () {
        controller.prepareEditTask(task);

        Get.bottomSheet(
          editTaskSheet(task.id),
          isScrollControlled: true,
          backgroundColor: AppColors.bgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        );
      },
      borderRadius: 16,
      backgroundColor: AppColors.primary,
      textColor: AppColors.bgColor,
    );
  }

  Widget _deleteButton(ResTask task) {
    return CustomElevatedButton(
      text: 'Delete Task',
      onPressed: () {
        controller.confirmDeleteTask(task.id);
      },
      borderRadius: 16,
      backgroundColor: AppColors.transparent,
      foregroundColor: AppColors.transparent,
      textColor: AppColors.withOpacity(AppColors.red, 0.7),
      borderWidth: 0.6,
      borderColor: AppColors.withOpacity(AppColors.red, 0.4),
    );
  }

  Widget editTaskSheet(String taskId) {
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
                        'Edit Task',
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
                _fieldLabel('Task Title'),
                gapH8,
                CustomTextField(
                  controller: controller.titleController,
                  hintText: 'Enter task title',
                  isMandatory: true,
                ),
                gapH20,
                _fieldLabel('Description'),
                gapH8,
                CustomTextField(
                  controller: controller.descriptionController,
                  hintText: 'Enter task description',
                  isMultiline: true,
                  isMandatory: true,
                ),
                gapH20,
                _fieldLabel('Due Date'),
                gapH8,
                CustomTextField(
                  controller: controller.dueDateController,
                  hintText: 'Select due date',
                  isDateField: true,
                  isMandatory: true,
                ),
                gapH20,
                _fieldLabel('Status'),
                gapH8,
                CustomDropdown(
                  hint: 'Select status',
                  items: const ['todo', 'in_progress', 'completed'],
                  selectedValue: controller.selectedStatus,
                  onChanged: (value) {
                    controller.selectedStatus.value = value;
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 15,
                  ),
                ),
                gapH20,
                _fieldLabel('Priority'),
                gapH8,
                CustomDropdown(
                  hint: 'Select priority',
                  items: const ['low', 'medium', 'high'],
                  selectedValue: controller.selectedPriority,
                  onChanged: (value) {
                    controller.selectedPriority.value = value;
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 15,
                  ),
                ),
                gapH28,
                CustomElevatedButton(
                  text: 'Update Task',
                  onPressed: () {
                    controller.updateTask(taskId);
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

  Widget _fieldLabel(String text) {
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