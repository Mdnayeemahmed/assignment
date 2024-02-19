import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/model.dart';
import '../utility/network_caller.dart'; // Import your RemoteService class here

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final RemoteService _remoteService = RemoteService();
  List<ProjectModel>? _projects;
  final GlobalKey<FormState> _inputKey = GlobalKey<FormState>();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectUpdateController =
  TextEditingController();
  final TextEditingController _assignedEngineerController =
  TextEditingController();
  final TextEditingController _assignedTechnicianController =
  TextEditingController();

  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

  final TextEditingController _editStartDateController = TextEditingController();
  final TextEditingController _editEndDateController = TextEditingController();
  final TextEditingController _editProjectNameController = TextEditingController();
  final TextEditingController _editProjectUpdateController = TextEditingController();
  final TextEditingController _editAssignedEngineerController = TextEditingController();
  final TextEditingController _editAssignedTechnicianController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    List<ProjectModel>? projects = await _remoteService.getProjects();
    setState(() {
      _projects = projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: _projects == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _projects!.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      _projects![index].projectName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_projects![index].projectUpdate} ',
                        ),
                        Text(
                          'Technician: ${_projects![index].assignedTechnician} ',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Duration: ${_projects![index].duration} days',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditProjectDialog(context, _projects![index]);
                          },
                        ),

                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('Start Date')),
                        DataColumn(label: Text('End Date')),
                        DataColumn(label: Text('Engineer')),
                        DataColumn(label: Text('Technician')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text(_projects![index].startDate.trim()),
                          ),
                          DataCell(
                            Text(_projects![index].endDate.trim()),
                          ),
                          DataCell(
                            Container( // Wrap with Container
                              width: double.infinity,
                              child: Text(
                                _projects![index].assignedEngineer.trim(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          DataCell(
                            Container( // Wrap with Container
                              width: double.infinity,
                              child: Text(
                                _projects![index].assignedTechnician.trim(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddProjectDialog(context);
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add_circle),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Project'),
          content: SingleChildScrollView(child: _taskAssignForm()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _submit();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _submit() async {
    final start = _startDateController.text;
    final end = _endDateController.text;
    final name = _projectNameController.text;
    final update = _projectUpdateController.text;
    final main = _assignedEngineerController.text;
    final support = _assignedTechnicianController.text;

    if (_inputKey.currentState?.validate() ?? false) {
      bool success = await _remoteService.addProject(
          start, end, name, update, main, support);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added Successfully"),
          ),
        );
        await _fetchProjects();
        _startDateController.clear();
        _endDateController.clear();
        _projectNameController.clear();
        _projectUpdateController.clear();
        _assignedEngineerController.clear();
        _assignedTechnicianController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something Went Wrong. Please Check"),
          ),
        );
      }
    }

    FocusScope.of(context).unfocus();
  }

  Form _taskAssignForm() {
    return Form(
      key: _inputKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _startDateController,
            decoration: InputDecoration(labelText: 'Start Date'),
            onTap: () {
              _selectDate(context, _startDateController);
            },
          ),
          TextField(
            controller: _endDateController,
            decoration: InputDecoration(labelText: 'End Date'),
            onTap: () {
              _selectDate(context, _endDateController);
            },
          ),
          TextField(
            controller: _projectNameController,
            decoration: InputDecoration(labelText: 'Project Name'),
          ),
          TextField(
            controller: _projectUpdateController,
            decoration: InputDecoration(labelText: 'Project Update'),
          ),
          TextField(
            controller: _assignedEngineerController,
            decoration: InputDecoration(labelText: 'Assigned Engineer'),
          ),
          TextField(
            controller: _assignedTechnicianController,
            decoration: InputDecoration(labelText: 'Assigned Technician'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProject(ProjectModel project) async {

    final url = 'https://scubetech.xyz/projects/dashboard/update-project-elements/${project.id}/';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {
      'start_date': project.startDate,
      'end_date': project.endDate,
      'project_name': project.projectName,
      'project_update': project.projectUpdate,
      'assigned_engineer': project.assignedEngineer,
      'assigned_technician': project.assignedTechnician,
    };

    final response = await http.put(Uri.parse(url), headers: headers, body: json.encode(body));

    print(response.body);

    if (response.statusCode == 200) {
      // Update successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Project Updated Successfully"),
        ),
      );
      await _fetchProjects();
    } else {
      // Update failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update project. Please try again."),
        ),
      );
    }
  }

  void _showEditProjectDialog(BuildContext context, ProjectModel project) {
    _editStartDateController.text = project.startDate;
    _editEndDateController.text = project.endDate;
    _editProjectNameController.text = project.projectName;
    _editProjectUpdateController.text = project.projectUpdate;
    _editAssignedEngineerController.text = project.assignedEngineer;
    _editAssignedTechnicianController.text = project.assignedTechnician;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Project'),
          content: SingleChildScrollView(child: _buildEditProjectForm(project)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a new ProjectModel object with updated values
                ProjectModel updatedProject = ProjectModel(
                  id: project.id,
                  startDate: _editStartDateController.text,
                  endDate: _editEndDateController.text,
                  projectName: _editProjectNameController.text,
                  projectUpdate: _editProjectUpdateController.text,
                  assignedEngineer: _editAssignedEngineerController.text,
                  assignedTechnician: _editAssignedTechnicianController.text,
                );

                // Now, update the project using the updated object
                _updateProject(updatedProject);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditProjectForm(ProjectModel project) {
    return Form(
      key: _editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _editStartDateController,
            decoration: InputDecoration(labelText: 'Start Date'),
            onTap: () {
              _selectDate(context, _editStartDateController);
            },
          ),
          TextFormField(
            controller: _editEndDateController,
            decoration: InputDecoration(labelText: 'End Date'),
            onTap: () {
              _selectDate(context, _editEndDateController);
            },
          ),
          TextFormField(
            controller: _editProjectNameController,
            decoration: InputDecoration(labelText: 'Project Name'),
          ),
          TextFormField(
            controller: _editProjectUpdateController,
            decoration: InputDecoration(labelText: 'Project Update'),
          ),
          TextFormField(
            controller: _editAssignedEngineerController,
            decoration: InputDecoration(labelText: 'Assigned Engineer'),
          ),
          TextFormField(
            controller: _editAssignedTechnicianController,
            decoration: InputDecoration(labelText: 'Assigned Technician'),
          ),
        ],
      ),
    );
  }
}


