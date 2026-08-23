import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/data/dataSources/mock_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
  });

  group('MockDataSource offline cache behavior', () {
    test(
      'previously loaded projects remain available while offline',
          () async {
        // First load while online.
        final onlineProjects = await dataSource.getProjects();

        expect(onlineProjects, isNotEmpty);

        // Enable offline mode.
        dataSource.setSimulation(offline: true);

        // Previously loaded projects should still be available.
        final offlineProjects = await dataSource.getProjects();

        expect(offlineProjects, isNotEmpty);
        expect(
          offlineProjects.length,
          onlineProjects.length,
        );
      },
    );

    test(
      'previously loaded tasks remain available while offline',
          () async {
        // First load while online.
        final onlineTasks = await dataSource.getTasks();

        expect(onlineTasks, isNotEmpty);

        // Enable offline mode.
        dataSource.setSimulation(offline: true);

        // Previously loaded tasks should still be available.
        final offlineTasks = await dataSource.getTasks();

        expect(offlineTasks, isNotEmpty);
        expect(
          offlineTasks.length,
          onlineTasks.length,
        );
      },
    );

    test(
      'project mutation fails while offline',
          () async {
        dataSource.setSimulation(offline: true);

        expect(
              () => dataSource.deleteProject(
            projectId: 'project_1',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'task mutation fails while offline',
          () async {
        dataSource.setSimulation(offline: true);

        expect(
              () => dataSource.deleteTask(
            taskId: 'task_1',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}