import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/dialogs.dart';
import '../../../shared/widgets/regx_validator.dart';
import '../models/request/req_create_project.dart';
import '../models/request/req_update_project.dart';
import '../models/response/res_project.dart';
import '../repositories/project_repo.dart';

class ProjectController extends GetxController {
  final ProjectRepository repository;
  ProjectController({
    required this.repository,
  });
  final isLoading = false.obs;
  final isDataLoaded = false.obs;
  final isDetailsLoading = false.obs;
  final isFormLoading = false.obs;
  final projects = <ResProject>[].obs;
  final selectedProject = Rxn<ResProject>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final isOrgAdmin = false.obs;


  @override
  void onInit() {
    super.onInit();
    checkAdmin();
    getProjects();
  }

  /// Check Role
  Future<void> checkAdmin() async {
    final storage = FlutterStorage();
    final keys = FlutterStorageKeys();

    final role = await storage.readStorage(keys.role);

    debugPrint('ADMIN CHECK: stored role = $role');

    isOrgAdmin.value =
        role.toString().trim().toLowerCase() == 'org_admin';

    debugPrint(
      'ADMIN CHECK: isOrgAdmin = ${isOrgAdmin.value}',
    );
  }

  /// Get Project List
  Future<void> getProjects() async {
    try {
      isLoading.value = true;

      final response = await repository.getProjects();

      projects.assignAll(response);
      isDataLoaded.value = true;
    } catch (e) {
      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh Project List
  Future<void> refreshProjects() async {
    try {
      final response = await repository.getProjects();

      projects.assignAll(response);
      isDataLoaded.value = true;
    } catch (e) {
      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Load Project Details
  Future<void> loadProjectDetails(String projectId) async {
    try {
      isDetailsLoading.value = true;
      selectedProject.value = null;

      final response = await repository.getProjectById(projectId);

      selectedProject.value = response;
    } catch (e) {
      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// Initialize Project Details
  void initializeProjectDetails() {
    final projectId = Get.arguments as String?;

    if (projectId != null && projectId.isNotEmpty) {
      loadProjectDetails(projectId);
    }
  }

  /// Create Project
  Future<void> createProject() async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast(
        'You are not authorized to create projects',
      );
      return;
    }

    final nameError = RegexValidator.validateProjectName(
      nameController.text,
    );

    if (nameError != null) {
      AppToast.errorToast(nameError);
      return;
    }

    final descriptionError =
    RegexValidator.validateProjectDescription(
      descriptionController.text,
    );

    if (descriptionError != null) {
      AppToast.errorToast(descriptionError);
      return;
    }

    try {
      isFormLoading.value = true;

      final request = ReqCreateProject(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
      );

      await repository.createProject(
        organizationId: 'org_a1b2c3',
        request: request,
      );

      clearForm();

      isFormLoading.value = false;

      Get.close(1);

      AppToast.successToast(
        'Project created successfully',
      );

      await refreshProjects();
    } catch (e) {
      isFormLoading.value = false;

      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Update Project
  Future<void> updateProject(String projectId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast(
        'You are not authorized to update projects',
      );
      return;
    }

    final nameError = RegexValidator.validateProjectName(
      nameController.text,
    );

    if (nameError != null) {
      AppToast.errorToast(nameError);
      return;
    }

    final descriptionError =
    RegexValidator.validateProjectDescription(
      descriptionController.text,
    );

    if (descriptionError != null) {
      AppToast.errorToast(descriptionError);
      return;
    }

    try {
      isFormLoading.value = true;

      final request = ReqUpdateProject(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
      );

      final updatedProject = await repository.updateProject(
        projectId,
        request,
      );

      selectedProject.value = updatedProject;

      final index = projects.indexWhere(
            (project) => project.id == projectId,
      );

      if (index != -1) {
        projects[index] = updatedProject;
      }

      clearForm();

      isFormLoading.value = false;

      Get.close(1);

      AppToast.successToast(
        'Project updated successfully',
      );
    } catch (e) {
      isFormLoading.value = false;

      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Confirm Project Delete
  Future<void> confirmDeleteProject(String projectId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast(
        'You are not authorized to delete projects',
      );
      return;
    }

    await Dialogs().deleteConfirm(
      title: 'Delete Project!',
      message: 'Are you sure you want to delete this project?',
      onDelete: () async {
        Get.back();
        await deleteProject(projectId);
      },
    );
  }

  /// Delete Project
  Future<void> deleteProject(String projectId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast(
        'You are not authorized to delete projects',
      );
      return;
    }

    try {
      isDetailsLoading.value = true;

      await repository.deleteProject(projectId);

      projects.removeWhere(
            (project) => project.id == projectId,
      );

      selectedProject.value = null;

      isDetailsLoading.value = false;

      Get.back();

      AppToast.successToast(
        'Project deleted successfully',
      );
    } catch (e) {
      isDetailsLoading.value = false;

      AppToast.errorToast(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Clear Form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
  }

  /// Dispose
  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}