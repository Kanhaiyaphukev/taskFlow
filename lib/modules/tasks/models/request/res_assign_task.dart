class ReqAssignTask {
  final String? assigneeId;

  const ReqAssignTask({
    this.assigneeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'assignee_id': assigneeId,
    };
  }
}