class OrgMemberModel {
  final String? id;
  final String orgId;
  final String userId;
  final String role;

  const OrgMemberModel({
    this.id,
    required this.orgId,
    required this.userId,
    required this.role,
  });

  factory OrgMemberModel.fromJson(Map<String, dynamic> json) {
    return OrgMemberModel(
      id: json['id'] as String?,
      orgId: json['org_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'user_id': userId,
      'role': role,
    };
  }

  bool get isAdmin => role == 'org_admin';
}