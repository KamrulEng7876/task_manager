import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/screen/add_new_task_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInProgress=false;
  bool _getTaskStatusCountListInProgress=false;

  bool _shouldRefreshPreviousPage=false;


  List<TaskModel>_newTaskList=[];
  List<TaskStatusModel>_taskStatusCountList=[];

  // int _taskCount = 0; // Add task count
  // int _taskStatusCountList=0;




  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInProgress,
                replacement: Center(child:CircularProgressIndicator()),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return  TaskCard(taskModel: _newTaskList[index],
                      onRefreshList: (){
                      _getNewTaskList();
                      },

                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        onPressed: _onTapAddFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return  Padding(
      padding: EdgeInsets.all(8),
      child: Visibility(
        visible: _getTaskStatusCountListInProgress==false,
        replacement: CenterCirculerProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children:_getTaskSummaryCardList()
          ),
        ),
      ),
    );
  }
  List<TaskSummaryCard>_getTaskSummaryCardList(){
    List<TaskSummaryCard>taskSummaryCardList=[];
    for(TaskStatusModel t in _taskStatusCountList){
    taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }

 Future <void> _onTapAddFAB()async {
   final bool? shouldRefresh=await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewTaskScreen(onTaskAdded: _refreshTaskList,),
      ),
    );

  }

  void _refreshTaskList() {
    _getNewTaskList(); // Refresh task list after a new task is added
  }

  Future<void>_getNewTaskList() async{
    _newTaskList.clear();
    _getNewTaskListInProgress=true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.newTaskList);
    if(response.isSuccess){
      // _shouldRefreshPreviousPage=true;
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _newTaskList=taskListModel.taskList??[];
      // _taskStatusCountList = _newTaskList.length;
      // _completedTaskCount = _completedTaskList.length;
    }else {
      showSnackBarMessage(context, response.errorMessage,true);
    }
    _getNewTaskListInProgress=false;
    setState(() {});
  }

  Future<void>_getTaskStatusCount() async{
    _taskStatusCountList.clear();
    _getTaskStatusCountListInProgress=true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListCount);
    if(response.isSuccess){
      // _shouldRefreshPreviousPage=true;
      final TaskStatusCountModel taskStatusCountModel=TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList=taskStatusCountModel.taskStatusCountList ??[];
      // _taskStatusCountList = _newTaskList.length;
      // _completedTaskCount = _completedTaskList.length;
    }else {
      showSnackBarMessage(context, response.errorMessage,true);
    }
    _getTaskStatusCountListInProgress=false;
    setState(() {});
  }

}


