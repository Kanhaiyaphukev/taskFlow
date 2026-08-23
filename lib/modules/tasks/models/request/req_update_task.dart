class ReqUpdateTask {
  final String title;
  final String description;
  final String status;
  final String priority;
  final String? assigneeId;
  final String dueDate;

  const ReqUpdateTask({
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'assignee_id': assigneeId,
      'due_date': dueDate,
    };
  }
}