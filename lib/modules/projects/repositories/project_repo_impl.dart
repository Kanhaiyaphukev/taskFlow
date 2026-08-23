import '../../../data/dataSources/mock_data_source.dart';
import '../models/request/req_create_project.dart';
import '../models/request/req_update_project.dart';
import '../models/response/res_project.dart';
import 'project_repo.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final MockDataSource dataSource;

  ProjectRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<ResProject>> getProjects() {
    return dataSource.getProjects();
  }

  @override
  Future<ResProject> getProjectById(
      String projectId,
      ) {
    return dataSource.getProjectById(
      projectId,
    );
  }

  @override
  Future<ResProject> createProject({
    required String organizationId,
    required ReqCreateProject request,
  }) {
    return dataSource.createProject(
      organizationId: organizationId,
      request: request,
    );
  }

  @override
  Future<ResProject> updateProject(
      String projectId,
      ReqUpdateProject request,
      ) {
    return dataSource.updateProject(
      projectId: projectId,
      request: request,
    );
  }

  @override
  Future<void> deleteProject(
      String projectId,
      ) {
    return dataSource.deleteProject(
      projectId: projectId,
    );
  }
}