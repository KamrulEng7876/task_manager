import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/screen/reset_passward_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgetPasswardOtpScreen extends StatefulWidget {
  const ForgetPasswardOtpScreen({super.key});

  @override
  State<ForgetPasswardOtpScreen> createState() =>
      _ForgetPasswardOtpScreenState();
}

class _ForgetPasswardOtpScreenState extends State<ForgetPasswardOtpScreen> {


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
                  'Pin Verification',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8,),
                Text('A 6 digit verification pin will send to your email',
                    style: textTheme.titleSmall?.copyWith(color: Colors.grey)),
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey, // Associate the form key here
                  child: Column(
                    children: [
                      _buildVerifyOtpForm(),
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

  Widget _buildVerifyOtpForm() {
    return Column(
      children: [

        PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.slide,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: AppColors.themeColor,
          ),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.blue.shade50,
          enableActiveFill: true,
          appContext: context,

          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter  valid otp code';
            }
            return null;
          },
        ),
        SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: Text('Verify'),
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Reset_Passward_Screen(),),);
  }

  void _onTapSignIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen(),),);

  }
}

