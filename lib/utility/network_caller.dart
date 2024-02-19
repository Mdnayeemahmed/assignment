import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model.dart'; // Import your Project class here

class RemoteService {
  Future<List<ProjectModel>?> getProjects() async {
    var url =
        'https://scubetech.xyz/projects/dashboard/all-project-elements/'; // Replace with your API endpoint
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ProjectModel> projects =
          jsonList.map((json) => ProjectModel.fromJson(json)).toList();
      return projects;
    } else {
      // If the server did not return a 200 OK response, return null
      return null;
    }
  }

  Future<bool> addProject(
      String start, end, name, update, main, support) async {
    var url = Uri.parse(
        'https://scubetech.xyz/projects/dashboard/add-project-elements/');
    var response = await http.post(
      url,
      body: {
        "start_date": start,
        "end_date": end,
        "project_name": name,
        "project_update": update,
        "assigned_engineer": main,
        "assigned_technician": support,
      },
    );


    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }




}
