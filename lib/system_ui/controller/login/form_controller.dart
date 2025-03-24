import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import '../../api/login/login_api.dart';

class FormController {
  // Initialize Data

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  String username = '';
  String password = '';
  final LoginApi loginApi = LoginApi();

  bool validateAndSaveForm() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  Map<String, dynamic> getFormData() {
    return formKey.currentState?.value ?? {};
  }

  bool areAllRequiredFieldsFilled(Map<String, dynamic> formData) {
    return formData['username'] != null && formData['password'] != null;
  }

  String? Function(String?) validateUsername() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Please enter your username'),
      // Add more form validators if necessary here
    ]);
  }

  String? Function(String?) validatePassword() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Please enter your password'),
      // Add more form validators if necessary here
    ]);
  }

  Future<bool> checkIfConnected() async {
    try {
      var response = await loginApi.getPing();
      print(response['message']);
      if (response['message'] == 'pong') {
        print('Ping successful');
        return true; // Connection successful
      } else {
        print('Ping failed');
        return false; // Connection failed
      }
    } catch (e) {
      // Show dialog on error
      print("Ping failed now in catch");
      print(e);
      return false; // Connection failed
    }
  }

  Future<Map<String, dynamic>> submitForm(BuildContext context) async {
    // check if connected

    if (validateAndSaveForm()) {
      final formData = getFormData();
      if (areAllRequiredFieldsFilled(formData)) {
        // databaseData.saveDataToDatabase(formData, true);

        final data = await loginApi.getUser(formData);
        if (data['access_control'] == 0) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Credentials')),
          );
        }
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form')),
      );
    }
    return {};
  }
}
