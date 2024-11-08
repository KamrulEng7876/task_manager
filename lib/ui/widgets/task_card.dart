import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel, required this.onRefreshList,
  });
  final TaskModel taskModel;
  final VoidCallback onRefreshList;


  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus= '';

  bool _changeStatusInProgress=false;
  bool _deleteTaskInProgress=false;

  @override
  void initState() {
    super.initState();
    _selectedStatus=widget.taskModel.status!;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              widget.taskModel.description?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Date:  ${widget.taskModel.createdDate?? ' '}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: _changeStatusInProgress==false,
                      replacement:  CircularProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapEditButton,
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.themeColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _deleteTaskInProgress==false,
                      replacement: CenterCirculerProgressIndicator(),
                      child: IconButton(
                        onPressed: _onTapDeleteButton,
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.themeColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New','Completed','Cancelled','progress'].map((e){
              return ListTile(
                onTap: (){
                  _changeStatus(e);
                  Navigator.pop(context);
                },
                title: Text(e),
                selected: _selectedStatus==e,
                trailing: _selectedStatus==e? Icon(Icons.check):null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _onTapDeleteButton()async{
    _deleteTaskInProgress=true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.deleteTask(widget.taskModel.sId!));
    if(response.isSuccess){
      widget.onRefreshList();

    }else{
      _deleteTaskInProgress=false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }

  }


 Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        widget.taskModel.status!,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(100),
        bottomRight: Radius.circular(100),
      )),
      side: BorderSide(color: AppColors.themeColor),
    );
  }

  Future<void>_changeStatus(String newStatus)async{
    _changeStatusInProgress=true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(widget.taskModel.sId!, newStatus));
    if(response.isSuccess){
      widget.onRefreshList();

    }else{
      _changeStatusInProgress=false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }
  
}
