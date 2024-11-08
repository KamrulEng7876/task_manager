import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, this.onTaskAdded});
final VoidCallback? onTaskAdded;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                ),
                Text(
                  'Add New task',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _titleTEController,
                  decoration: InputDecoration(hintText: 'Title'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty??true) {
                      return 'Please enter a value ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _descriptionTEController,
                  maxLines: 7,
                  decoration: InputDecoration(hintText: 'Description'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty??true) {
                      return 'Please enter a value ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: !_addNewTaskInProgress,
                  replacement: CenterCirculerProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
      _addNewTask();
    }

  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New',
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.addNewtask, body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'New Task added');
      widget.onTaskAdded?.call();  // Call the callback to refresh the list
      Navigator.pop(context);
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}




// import 'package:flutter/material.dart';
// import 'package:task_manager/data/models/network_response.dart';
// import 'package:task_manager/data/services/network_caller.dart';
// import 'package:task_manager/data/utils/utils.dart';
// import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
// import 'package:task_manager/ui/widgets/snack_bar_message.dart';
// import 'package:task_manager/ui/widgets/tm_app_bar.dart';
//
// class AddNewTaskScreen extends StatefulWidget {
//   final VoidCallback? onTaskAdded;
//
//   const AddNewTaskScreen({super.key, this.onTaskAdded});
//
//   @override
//   State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
// }
//
// class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
//   final TextEditingController _titleTEController = TextEditingController();
//   final TextEditingController _descriptionTEController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _addNewTaskInProgress = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TMAppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 42),
//                 Text(
//                   'Add New Task',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   controller: _titleTEController,
//                   decoration: InputDecoration(hintText: 'Title'),
//                   validator: (String? value) {
//                     if (value?.trim().isEmpty ?? true) {
//                       return 'Please enter a value ';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   controller: _descriptionTEController,
//                   maxLines: 7,
//                   decoration: InputDecoration(hintText: 'Description'),
//                   validator: (String? value) {
//                     if (value?.trim().isEmpty ?? true) {
//                       return 'Please enter a value ';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 Visibility(
//                   visible: !_addNewTaskInProgress,
//                   replacement: CenterCirculerProgressIndicator(),
//                   child: ElevatedButton(
//                     onPressed: _onTapSubmitButton,
//                     child: Icon(Icons.arrow_circle_right_outlined),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onTapSubmitButton() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Processing Data')),
//       );
//       _addNewTask();
//     }
//   }
//
//   Future<void> _addNewTask() async {
//     _addNewTaskInProgress = true;
//     setState(() {});
//     Map<String, dynamic> requestBody = {
//       'title': _titleTEController.text.trim(),
//       'description': _descriptionTEController.text.trim(),
//       'status': 'New',
//     };
//     final NetworkResponse response = await NetworkCaller.postRequest(
//       url: Urls.addNewtask,
//       body: requestBody,
//     );
//     _addNewTaskInProgress = false;
//     setState(() {});
//
//     if (response.isSuccess) {
//       _clearTextFields();
//       showSnackBarMessage(context, 'New Task added');
//       widget.onTaskAdded?.call(); // Trigger callback to refresh NewTaskScreen
//       // Navigator.pop(context); // Close AddNewTaskScreen
//     } else {
//       showSnackBarMessage(context, response.errorMessage, true);
//     }
//   }
//
//   void _clearTextFields() {
//     _titleTEController.clear();
//     _descriptionTEController.clear();
//   }
// }
