import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/forget_passward_otp_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswardEmailScreen extends StatefulWidget {
  const ForgetPasswardEmailScreen({super.key});

  @override
  State<ForgetPasswardEmailScreen> createState() =>
      _ForgetPasswardEmailScreenState();
}

class _ForgetPasswardEmailScreenState extends State<ForgetPasswardEmailScreen> {
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
                  'Your Email Address',
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
                      _buildVerifyEmailForm(),
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

  Widget _buildVerifyEmailForm() {
    return Column(
      children: [
        TextFormField(
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
          child: Icon(Icons.arrow_circle_right_outlined),
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
        builder: (context) => ForgetPasswardOtpScreen(),
      ),
    );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }
}
