import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../api/database.dart';

class FormController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  double latitude = 0;
  double longitude = 0;
  bool isRealData = false;
  String email = '';
  bool isEvacuationSite = false;
  final List<String> evacuationSitesTypes = [
    'Covered Court',
    'Barangay Center',
    'School',
    'Others'
  ];
  late final DatabaseData databaseData;
  final Databases database = GetIt.I<Databases>();
  final Client client = GetIt.I<Client>();

  FormController() {
    databaseData = DatabaseData(client, database);
  }

  void setCoordinates(String latitude, String longitude, String email) {
    this.latitude = double.parse(latitude);
    this.longitude = double.parse(longitude);
    this.email = email;
  }

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
          formData['evacuation_center_current_accommodation'] != null;
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

  String? Function(String?) validatePhotos() {
    return (String? value) {
      return null;
    };
  }

  void submitForm(
      BuildContext context, Function(Map<String, dynamic>) onSuccess) {
    if (validateAndSaveForm()) {
      final formData = getFormData();
      if (areAllRequiredFieldsFilled(formData)) {
        // Process the form data
        final data = processFormData(formData);

        if (isEvacuationSite) {
          databaseData.saveDataToDatabase(data, true);
        } else {
          databaseData.saveDataToDatabase(data, false);
        }

        onSuccess(data);
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

  Map<String, dynamic> processFormData(Map<String, dynamic> formData) {
    final data = <String, dynamic>{
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'photo_reference': formData['photo_reference'],
    };

    if (formData['evacuation_site'] == false) {
      data.addAll({
        'date_time': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
            .format((formData['calendar'] as DateTime).toUtc()),
        'flood_level': double.parse(formData['flood_level']),
        'data_type': formData['data_type'],
        'reference': formData['reference'],
      });
    } else {
      data.addAll({
        'evacuation_center_name': formData['evacuation_center_name'],
        'evacuation_center_type': formData['evacuation_center_type'],
        'evacuation_center_capacity':
            int.parse(formData['evacuation_center_capacity']),
        'evacuation_center_accommodation':
            int.parse(formData['evacuation_center_current_accommodation']),
      });
    }

    return data;
  }
}
