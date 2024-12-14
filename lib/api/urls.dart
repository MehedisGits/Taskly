final String baseUrl = 'http://35.73.30.144:2005/api/v1';
final String registrationUrl = '$baseUrl/Registration';
final String loginUrl = '$baseUrl/Login';
final String profileUpdateUrl = '$baseUrl/ProfileUpdate';
final String addNewTaskUrl = '$baseUrl/createTask';
final String getTaskStatusCount = '$baseUrl/taskStatusCount';

String deleteTask(String taskId) => '$baseUrl/deleteTask/$taskId';
final String getNewTaskListUrl = '$baseUrl/listTaskByStatus/New';
final String getCompletedTaskListUrl = '$baseUrl/listTaskByStatus/Completed';
final String getProgressTaskListUrl = '$baseUrl/listTaskByStatus/Progress';
final String getCancelledTaskListUrl = '$baseUrl/listTaskByStatus/Cancelled';

String updateTaskStatus(String taskId, String status) =>
    '$baseUrl/updateTaskStatus/$taskId/$status';
