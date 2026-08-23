import '../models/request/req_create_project.dart';
import '../models/request/req_update_project.dart';
import '../models/response/res_project.dart';

abstract class ProjectRepository {
  Future<List<ResProject>> getProjects();

  Future<ResProject> getProjectById(
      String projectId,
      );

  Future<ResProject> createProject({
    required String organizationId,
    required ReqCreateProject request,
  });

  Future<ResProject> updateProject(
      String projectId,
      ReqUpdateProject request,
      );

  Future<void> deleteProject(
      String projectId,
      );
}