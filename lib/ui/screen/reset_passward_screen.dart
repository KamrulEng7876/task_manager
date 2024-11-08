import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/screen/forget_passward_otp_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class Reset_Passward_Screen extends StatefulWidget {
  const Reset_Passward_Screen({super.key, });


  @override
  State<Reset_Passward_Screen> createState() =>
      _Reset_Passward_ScreenState();
}

class _Reset_Passward_ScreenState extends State<Reset_Passward_Screen> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _setPasswordInProgress = false;
  final _formKey = GlobalKey<FormState>();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  'Set Password',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8,),
                Text('Minimum length password 8 character with latter and number combination',
                    style: textTheme.titleSmall?.copyWith(color: Colors.grey)),
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey, // Associate the form key here
                  child: Column(
                    children: [
                      _buildResetPasswordForm(),
                      SizedBox(
                        height: 48,
                      ),

                      // SizedBox(height: ,),
                      _buildSignInSection()
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

  Widget _buildResetPasswordForm() {
    return Column(
      children: [
        TextFormField(

          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _obscureText,
          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.lock),
            hintText: 'New Password',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(
          height: 16,
        ),TextFormField(

          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.lock),
            hintText: 'Confirm Password',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        text: "Have Account? ",
        children: [
          TextSpan(
              text: "Sign In",
              style: TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }





  void _onTapSignIn() {
    Navigator.pop(context);
  }
  @override
  void dispose() {
    super.dispose();
  }
}
