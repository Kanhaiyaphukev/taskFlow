import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/data/dataSources/mock_data_source.dart';
import 'package:task_flow/modules/auth/models/request/req_login.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
  });

  group('MockDataSource simulation', () {
    test('simulation is disabled by default', () {
      expect(dataSource.simulateError, isFalse);
      expect(dataSource.simulateOffline, isFalse);
      expect(dataSource.responseDelay, Duration.zero);
    });

    test('setSimulation enables error simulation', () {
      dataSource.setSimulation(error: true);

      expect(dataSource.simulateError, isTrue);
      expect(dataSource.simulateOffline, isFalse);
      expect(dataSource.responseDelay, Duration.zero);
    });

    test('setSimulation enables offline simulation', () {
      dataSource.setSimulation(offline: true);

      expect(dataSource.simulateError, isFalse);
      expect(dataSource.simulateOffline, isTrue);
      expect(dataSource.responseDelay, Duration.zero);
    });

    test('setSimulation configures response delay', () {
      const delay = Duration(milliseconds: 500);

      dataSource.setSimulation(delay: delay);

      expect(dataSource.responseDelay, delay);
    });

    test('setSimulation can configure multiple values', () {
      const delay = Duration(seconds: 1);

      dataSource.setSimulation(
        error: true,
        offline: true,
        delay: delay,
      );

      expect(dataSource.simulateError, isTrue);
      expect(dataSource.simulateOffline, isTrue);
      expect(dataSource.responseDelay, delay);
    });

    test('resetSimulation restores default state', () {
      dataSource.setSimulation(
        error: true,
        offline: true,
        delay: const Duration(seconds: 1),
      );

      dataSource.resetSimulation();

      expect(dataSource.simulateError, isFalse);
      expect(dataSource.simulateOffline, isFalse);
      expect(dataSource.responseDelay, Duration.zero);
    });

    test('error simulation causes login to throw', () async {
      dataSource.setSimulation(error: true);

      expect(
        dataSource.login(
          ReqLogin(
            email: 'test@example.com',
            password: 'password',
          ),
        ),
        throwsA(
          predicate(
                (error) =>
            error is Exception &&
                error.toString().contains(
                  'Simulated server error',
                ),
          ),
        ),
      );
    });

    test('offline simulation causes login to throw', () async {
      dataSource.setSimulation(offline: true);

      expect(
        dataSource.login(
          ReqLogin(
            email: 'test@example.com',
            password: 'Password123!',
          ),
        ),
        throwsA(
          predicate(
                (error) =>
            error is Exception &&
                error.toString().contains(
                  'You are offline',
                ),
          ),
        ),
      );
    });

    test('normal mode allows login request to reach data source', () async {
      expect(dataSource.simulateError, isFalse);
      expect(dataSource.simulateOffline, isFalse);

      expect(
        dataSource.login(
          ReqLogin(
            email: 'test@example.com',
            password: 'wrong-password',
          ),
        ),
        throwsA(
          predicate(
                (error) =>
            error is Exception &&
                error.toString().contains(
                  'Invalid email or password',
                ),
          ),
        ),
      );
    });
  });
}