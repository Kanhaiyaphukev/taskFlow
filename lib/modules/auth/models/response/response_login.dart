import '../../../../shared/models/org_member_model.dart';
import '../../../../shared/models/org_model.dart';
import '../../../../shared/models/user_model.dart';

class ResLogin {
  final UserModel user;
  final OrgModel organization;
  final OrgMemberModel membership;
  final String accessToken;
  final String refreshToken;

  const ResLogin({
    required this.user,
    required this.organization,
    required this.membership,
    required this.accessToken,
    required this.refreshToken,
  });

  bool get isAdmin => membership.role == 'org_admin';

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'organization': organization.toJson(),
      'membership': membership.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}