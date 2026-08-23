import '../models/response/res_profile.dart';

abstract class ProfileRepository {
  Future<ResProfile> getProfile({
    required String userId,
    required String organizationId,
  });
}