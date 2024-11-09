import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../controller/form_controller.dart';

class MapForm extends StatefulWidget {
  const MapForm(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.email});

  final String latitude;
  final String longitude;
  final String email;

  @override
  MapFormState createState() => MapFormState();
}

class MapFormState extends State<MapForm> {
  final FormController _controller = FormController();

  @override
  void initState() {
    super.initState();
    _controller.setCoordinates(widget.latitude, widget.longitude, widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FormBuilder(
        key: _controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Text("Location Coordinates",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'Latitude: ${widget.latitude}\nLongitude: ${widget.longitude}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            FormBuilderSwitch(
              name: "evacuation_site",
              decoration: InputDecoration(
                icon: Icon(Icons.house),
              ),
              title: Text(
                "Evacuation Site?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              initialValue: false,
              onChanged: (value) {
                setState(() {
                  _controller.toggleEvacuationSite(value);
                });
              },
            ),
            SizedBox(height: 10),
            if (!_controller.isEvacuationSite)
              Column(
                children: [
                  FormBuilderRadioGroup(
                    name: 'data_type',
                    decoration: InputDecoration(
                      icon: Icon(Icons.data_object_rounded),
                      labelText: 'Type of Data',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: true, child: Text('Real Data')),
                      FormBuilderFieldOption(
                          value: false, child: Text('Dummy Data')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _controller.toggleRealData(value);
                      });
                    },
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: 'calendar',
                    format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Date and Time of Observation',
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'flood_level',
                    decoration: InputDecoration(
                      icon: Icon(Icons.flood),
                      labelText: 'Observed Flood Level (in meters)',
                    ),
                    validator: _controller.validateFloodLevel(),
                  ),
                  SizedBox(height: 10),
                  if (_controller.isRealData)
                    FormBuilderTextField(
                      name: 'reference',
                      decoration: InputDecoration(
                        icon: Icon(Icons.link),
                        labelText: 'Reference',
                      ),
                      validator: _controller.validateReference,
                    ),
                ],
              ),
            if (_controller.isEvacuationSite)
              Column(
                children: [
                  FormBuilderTextField(
                    name: 'evacuation_center_name',
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_pin),
                      labelText: 'Evacuation Center Name',
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'evacuation_center_type',
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_city),
                      labelText: 'Evacuation Center Type',
                    ),
                    items: _controller.evacuationSitesTypes
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'evacuation_center_capacity',
                    decoration: InputDecoration(
                      icon: Icon(Icons.family_restroom),
                      labelText: 'Evacuation Center Maximum Capacity',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'evacuation_center_current_accommodation',
                    decoration: InputDecoration(
                      icon: Icon(Icons.list),
                      labelText: 'Evacuation Center Current Accommodation',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0),
                    ]),
                  ),
                ],
              ),
            SizedBox(height: 10),
            FormBuilderTextField(
              name: 'photo_reference',
              decoration: InputDecoration(
                icon: Icon(Icons.camera),
                labelText: 'Photo Reference (URL)',
              ),
              validator: _controller.validatePhotos(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                _controller.submitForm(context, (formData) {});
                if (_controller.formKey.currentState!.saveAndValidate()) {
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
