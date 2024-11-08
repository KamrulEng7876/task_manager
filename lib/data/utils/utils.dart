class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1/';
  static const String registration = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static const String addNewtask = '$_baseUrl/CreateTask';
  static const String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static const String completedTaskList =
      '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTaskList =
      '$_baseUrl/listTaskByStatus/Cancelled';
  static const String progressTaskList =
      '$_baseUrl/listTaskByStatus/Progress';

  static const String updateProfile =
      '$_baseUrl/ProfileUpdate';


  // static const String taskListCount = '$_baseurl/taskStatusCount';
  static const String taskListCount =
      '$_baseUrl/taskStatusCount';


  static String changeStatus(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTask(String taskId) =>
      '$_baseUrl/deleteTask/$taskId';


  static String recoverVerifyEmail(String email) =>
      '$_baseUrl/RecoverVerifyEmail/email@gmail.com/$email';

  static String recoverVerifyOtp(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOtp/email@gmail.com/121465/$email/$otp';

  static const String recoverResetPassword = '$_baseUrl/RecoverResetPassword';



}
