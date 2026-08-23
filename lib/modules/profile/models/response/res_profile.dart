import '../../../../shared/models/org_member_model.dart';
import '../../../../shared/models/org_model.dart';
import '../../../../shared/models/user_model.dart';

class ResProfile {
  final UserModel user;
  final OrgModel organization;
  final OrgMemberModel membership;

  const ResProfile({
    required this.user,
    required this.organization,
    required this.membership,
  });

  factory ResProfile.fromJson(Map<String, dynamic> json) {
    return ResProfile(
      user: UserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
      organization: OrgModel.fromJson(
        json['organization'] as Map<String, dynamic>,
      ),
      membership: OrgMemberModel.fromJson(
        json['membership'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'organization': organization.toJson(),
      'membership': membership.toJson(),
    };
  }
}