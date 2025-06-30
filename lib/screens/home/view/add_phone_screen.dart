import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class AddPhoneScreen extends StatefulWidget {
  final String name;
  final void Function(String name, String phoneNumber, String countryCode)
      onSaveClick;
  const AddPhoneScreen({
    super.key,
    required this.name,
    required this.onSaveClick,
  });

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String _countryCode = '+966';

  @override
  void initState() {
    super.initState();
    _countryCode = '+966';
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).edit_information),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => widget.onSaveClick(_nameController.text, _phoneController.text, _countryCode),
        backgroundColor: Colors.green,
        tooltip: S.of(context).edit_information,
        icon: const Icon(Icons.save),
        label: Text(S.of(context).save_changes),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: S.of(context).name,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    DataValidator.validateName(context, value),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (code) {
                      setState(() {
                        _countryCode = code.dialCode ?? '+966';
                      });
                    },
                    initialSelection: _countryCode,
                    favorite: const ['+966', 'SA'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    textStyle: CustomStyle.smallText,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: S.of(context).phone,
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                          DataValidator.validatePhone(context, value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
