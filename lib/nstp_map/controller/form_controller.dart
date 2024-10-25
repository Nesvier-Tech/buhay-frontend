import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool isRealData = false;
  bool isEvacuationSite = false;
  final List<String> evacuationSitesTypes = [
    'Covered Court',
    'Barangay Center',
    'School',
    'Others'
  ];

  void toggleRealData(bool? value) {
    isRealData = value ?? false;
  }

  void toggleEvacuationSite(bool? value) {
    isEvacuationSite = value ?? false;
  }

  bool validateAndSaveForm() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  Map<String, dynamic> getFormData() {
    return formKey.currentState?.value ?? {};
  }

  bool areAllRequiredFieldsFilled(Map<String, dynamic> formData) {
    if (isEvacuationSite) {
      return formData['evacuation_center_name'] != null &&
          formData['evacuation_center_type'] != null &&
          formData['evacuation_center_capacity'] != null &&
          formData['evacuation_center_current_accomodation'] != null;
    } else {
      return formData['calendar'] != null &&
          formData['flood_level'] != null &&
          formData['data_type'] != null &&
          (!isRealData || formData['reference'] != null) &&
          formData['evacuation_site'] != null;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat("EEEE, MMMM d, yyyy 'at' h:mma").format(date);
  }

  String? Function(String?) validateFloodLevel() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Please enter a flood level'),
      FormBuilderValidators.numeric(errorText: 'Please enter a valid number'),
      FormBuilderValidators.min(0,
          errorText: 'Flood level must be non-negative'),
    ]);
  }

  String? validateReference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a reference';
    }
    return null;
  }

  String? Function(String) validateEvacuationCenterCapacity() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
          errorText: 'Please enter the maximum capacity'),
      FormBuilderValidators.numeric(errorText: 'Please enter a valid number'),
      FormBuilderValidators.min(0, errorText: 'Capacity must be non-negative'),
    ]);
  }

  String? Function(String?) validateEvacuationCenterCurrentAccommodation() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
          errorText: 'Please enter the current accommodation'),
      FormBuilderValidators.numeric(errorText: 'Please enter a valid number'),
      FormBuilderValidators.min(0,
          errorText: 'Current accommodation must be non-negative'),
    ]);
  }

  void submitForm(
      BuildContext context, Function(Map<String, dynamic>) onSuccess) {
    if (validateAndSaveForm()) {
      final formData = getFormData();
      if (areAllRequiredFieldsFilled(formData)) {
        // Process the form data
        onSuccess(formData);
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
  }
}
