import '../models/request/req_login.dart';
import '../models/response/response_login.dart';

abstract class AuthRepository {
  Future<ResLogin> login(ReqLogin request);

  Future<String> refreshToken(String refreshToken);
}
