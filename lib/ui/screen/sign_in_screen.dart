import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screen/forget_passward_email_screen.dart';
import 'package:task_manager/ui/screen/main_bottom_navbar_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController=TextEditingController();
  final TextEditingController _passwordTEController=TextEditingController();
  bool _inProgress=false;
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 85,
                ),
                Text(
                  'Get Started With',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey, // Associate the form key here
                  child: Column(
                    children: [
                      _buildSignInForm(),
                      SizedBox(
                        height: 24,
                      ),
                      TextButton(
                        onPressed: _onTapForgetPasswordButton,
                        child: Text(
                          'Forget Passward?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      // SizedBox(height: ,),
                      _buildSignUpSection()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _emailTEController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your valid email';
            }
            if (!value!.contains('@')) {
              return "Enter valid email '@'";
            }
            if (!value.contains('.com')) {
              return "Enter valid email '.com'";
            }
            return null;

          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _passwordTEController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: hidePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: hidePassword
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
            ),
            hintText: 'Passward',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the vali passward';
            }
            if (value!.length <= 5) {
              return "Enter valid Password more then 6 letter";
            }
            return null;
          },
        ),
        SizedBox(
          height: 16,
        ),
        Visibility(
          visible: _inProgress==false,
          replacement: const CircularProgressIndicator(),
          child: ElevatedButton(
            onPressed:_onTapNextButton,
            child: Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          text: "Don't have an account? ",
          children: [
            TextSpan(
                text: "Sign up",
                style: TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap= _onTapSignUp

            ),
          ],
      ),
    );
  }

  void _onTapNextButton(){

    if (!_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Processing Data')),
      // );
      return;
    }
    _signIn();

  }


  Future<void> _signIn() async {
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      'email': _emailTEController.text.trim(),
      'password': _passwordTEController.text,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.login, body: requestBody);

    setState(() {
      _inProgress = false;
    });

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);

      // Save token if it exists
      if (loginModel.token != null) {
        await AuthController.saveAccessToken(loginModel.token!);
      }

      // Check if user data exists before attempting to save
      if (loginModel.data != null) {
        await AuthController.saveUserData(loginModel.data!);

        // Navigate to the main screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainBottomNavbarScreen()),
              (route) => false,
        );
      } else {
        showSnackBarMessage(context, 'User data is missing', true);
      }
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }



  // Future<void> _signIn()async{
  //
  //   _inProgress=true;
  //   setState(() {});
  //   Map<String, dynamic> requestBody={
  //     'email':_emailTEController.text.trim(),
  //     'password':_passwordTEController.text,
  //   };
  //
  //   final NetworkResponse response =
  //       await NetworkCaller.postRequest(url: Urls.login,body: requestBody);
  //
  //   _inProgress=false;
  //   setState(() {});
  //   if(response.isSuccess){
  //     LoginModel loginModel=LoginModel.fromJson(response.responseData);
  //     await AuthController.saveAccessToken(loginModel.token!);
  //     await AuthController.saveUserData(loginModel.data!.first);
  //
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainBottomNavbarScreen()),
  //             (Value) => false);
  //   }else{
  //     showSnackBarMessage(context, response.errorMessage,true);
  //   }
  // }

  void _onTapForgetPasswordButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswardEmailScreen(),),);
  }
  void _onTapSignUp(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

}

