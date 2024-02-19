class ProjectModel {
  final int id;
  final String startDate;
  final String endDate;
  final int? startDayOfYear; // Change to int?
  final int? endDayOfYear; // Change to int?
  final String projectName;
  final String projectUpdate;
  final String assignedEngineer;
  final String assignedTechnician;
  final int? duration;

  ProjectModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.startDayOfYear, // Change to int?
    this.endDayOfYear, // Change to int?
    required this.projectName,
    required this.projectUpdate,
    required this.assignedEngineer,
    required this.assignedTechnician,
    this.duration,
  });

  // Factory method to create a Project object from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startDayOfYear: json['start_day_of_year'],
      endDayOfYear: json['end_day_of_year'],
      projectName: json['project_name'],
      projectUpdate: json['project_update'],
      assignedEngineer: json['assigned_engineer'],
      assignedTechnician: json['assigned_technician'],
      duration: json['duration'],
    );
  }
}
