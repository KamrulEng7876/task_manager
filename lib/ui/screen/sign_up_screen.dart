import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _inProgress = false;

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
                  'Join With Us',
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
                      _buildSignUpForm(),
                      SizedBox(
                        height: 24,
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

  Widget _buildSignUpForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailTEController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          height: 8,
        ),
        TextFormField(
          controller: _firstNameTEController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.person),
            hintText: 'First Name',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _lastNameTEController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Last Name',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _mobileTEController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            // labelText: 'Enter your name',
            prefixIcon: Icon(Icons.phone),
            hintText: 'Mobile',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white
                .withOpacity(0.8), // Ensure good visibility on any background
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter A valid mobile number';
            }
            return null;
          },
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _passwordTEController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.visiblePassword,
          // obscureText: hidePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: 'Passward',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the vali passward';
            }
            return null;
          },
        ),
        SizedBox(
          height: 16,
        ),
        Visibility(
          visible: _inProgress==false,
          replacement: CircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextButton,
            child: Icon(Icons.arrow_circle_right_outlined),
          ),
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
      _signUp();
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }

  Future<void> _signUp() async {
    _inProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody ={
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
       url:Urls.registration,
       body:requestBody,
       );
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      _clearTextFields();
     showSnackBarMessage(context,'New user Create');
    }else{
      showSnackBarMessage(context,response.errorMessage,true);
    }
  }

  void _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }
  void _onTapSignIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
