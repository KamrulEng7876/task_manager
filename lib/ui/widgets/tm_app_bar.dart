import 'package:flutter/material.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screen/profile_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen=false,
  });
  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(isProfileScreenOpen){
          return;

        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(),),);
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.cyan,
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(


                 AuthController.userData?.fullName??'',
                 //    'kamrul hasan',
                    style: TextStyle(fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    // 'kamrul@gmail.com',
                    AuthController.userData?.email??'',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
            IconButton(onPressed: () async {
              await AuthController.clearUserData();

              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (predicate)=>false);
            },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
