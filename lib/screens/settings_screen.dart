import 'package:flutter/material.dart';
import 'package:tip_calc/db/db.dart';
import 'package:tip_calc/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double tip = 0;
  bool isErrorInForm = false;
  TextEditingController tipController = TextEditingController();
  final dbInstance = DB();

  @override
  void initState() {
    super.initState();
    tipController.addListener(() {
      if (tipController.text != '' && !tipController.text.startsWith('-')) {
        if (int.parse(tipController.text) >= 0) {
          isErrorInForm = false;
        }
      } else {
        isErrorInForm = true;
      }
      setState(() {});
    });
    getSettings();
  }

  getSettings() async {
    tip = await dbInstance.getTipSetting() ?? 15;
    tipController.text = tip.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              CustomTextFormField(
                controller: tipController,
                labelText: 'Tip percentage',
                hintText: 'Type the tip percentage',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != '' && !value!.startsWith('-')) {
                    if (double.parse(value) >= 0) {
                      return null;
                    }
                  }
                  return "Un número es obligatorio.";
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: (isErrorInForm)
                      ? null
                      : () {
                          dbInstance
                              .saveTipSetting(double.parse(tipController.text));
                          FocusScope.of(context).requestFocus(FocusNode());
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Tip changed successfully!')));
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Save settings")
                    ],
                  ))
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
