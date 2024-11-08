import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/utils.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController=TextEditingController();
  final TextEditingController _firstNameTEController=TextEditingController();
  final TextEditingController _lastNameTEController=TextEditingController();
  final TextEditingController _phoneTEController=TextEditingController();
  final TextEditingController _passwordTEController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  XFile? _selectedImage;

  bool _updateProfileInProgress =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserData();
  }

  void _setUserData(){
    _emailTEController.text=AuthController.userData?.email??'';
    _firstNameTEController.text=AuthController.userData?.firstName??'';
    _lastNameTEController.text=AuthController.userData?.lastName??'';
    _phoneTEController.text=AuthController.userData?.mobile??'';
    // _passwordTEController.text=AuthController.userData?.password??'';

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Update Profile',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 32,
                ),
                _buildPhotoPicker(),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Email'),

                  validator: (String? value) {
                    if (value?.trim().isEmpty??true) {
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
                    controller: _firstNameTEController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please Enter your first Name';
                      }
                      return null;
                    }
                    ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Last Name',
                  ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please Enter your last Name';
                      }
                      return null;
                    }
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _phoneTEController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Mobile',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Mobile number';
                    }
                    if (value.length < 11 || value.length > 11) { // Adjust based on valid length range
                      return 'Please enter a valid phone number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Mobile number must contain only digits';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(

                  controller: _passwordTEController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'password',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _updateProfileInProgress==false,
                  replacement: CenterCirculerProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _updateProfile();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void>_updateProfile()async{
    _updateProfileInProgress=true;
    setState(() {});
    Map <String,dynamic> requestBody={
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
    };
    if(_passwordTEController.text.isNotEmpty){
      requestBody['password']=_passwordTEController.text;
    }
    if(_selectedImage!=null){
     List<int> imageBytes=await _selectedImage!.readAsBytes();
     String convertedImage=base64Encode(imageBytes);
     requestBody['photo']=convertedImage;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfile, body: requestBody,
    );
    _updateProfileInProgress=false;
    setState(() {});
    if(response.isSuccess){
      UserModel userModel=UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMessage(context, response.errorMessage);
    }else{

    }
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: (){
        _pickImage();
      },
      child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          )),
                      alignment: Alignment.center,
                      child: Text(
                        'Photo',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    Text(_getSelectedPhotoTitle()),
                  ],
                ),
              ),
    );
  }

  String _getSelectedPhotoTitle(){
    if(_selectedImage!=null){
      return _selectedImage!.name;
    }
    return 'Select Photo';
  }
  Future <void>_pickImage()async{
    ImagePicker _imagePicker=ImagePicker();
    XFile? pickedImage= await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      _selectedImage=pickedImage;
      setState(() {});
    }
  }
}
