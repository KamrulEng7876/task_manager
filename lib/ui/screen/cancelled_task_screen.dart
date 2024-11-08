import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress=false;
  List<TaskModel>_cancelledTaskList=[];




  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCancelledTaskListInProgress,
      replacement: CenterCirculerProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: ()async{
          _getCancelledTaskList();
        },
        child: ListView.separated(
          itemCount: _cancelledTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _cancelledTaskList[index],
              onRefreshList: (){
                _getCancelledTaskList();
              },
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }
  Future<void>_getCancelledTaskList() async{
    _cancelledTaskList.clear();
    _getCancelledTaskListInProgress=true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.cancelledTaskList);
    if(response.isSuccess){
      // _shouldRefreshPreviousPage=true;
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _cancelledTaskList=taskListModel.taskList??[];
      // _completedTaskCount = _completedTaskList.length;
    }else {
      showSnackBarMessage(context, response.errorMessage,true);
    }
    _getCancelledTaskListInProgress=false;
    setState(() {});
  }
}
