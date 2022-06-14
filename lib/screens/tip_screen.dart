import 'package:flutter/material.dart';
import 'package:tip_calc/db/db.dart';
import 'package:tip_calc/screens/screens.dart';
import 'package:tip_calc/widgets/widgets.dart';

class TipScreen extends StatefulWidget {
  const TipScreen({Key? key}) : super(key: key);

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController tipController = TextEditingController();
  TextEditingController poepleController = TextEditingController();
  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  bool isResultVisible = false,
      isErrorInFormAmount = true,
      isErrorInFormPeople = true;

  int peopleForBill = 0;
  double billAmount = 0,
      tipOfAmount = 0,
      personTip = 0,
      totalAmount = 0,
      tip = 0;
  @override
  void initState() {
    super.initState();
    getSettings();
    amountController.addListener(() {
      if (amountController.text != '' &&
          !amountController.text.startsWith('-')) {
        if (double.parse(amountController.text) >= 0) {
          isErrorInFormAmount = false;
        }
      } else {
        isErrorInFormAmount = true;
      }
      setState(() {});
    });
    poepleController.addListener(() {
      if (poepleController.text != '' &&
          !poepleController.text.startsWith('-')) {
        if (int.parse(poepleController.text) >= 0) {
          isErrorInFormPeople = false;
        }
      } else {
        isErrorInFormPeople = true;
      }
      setState(() {});
    });
  }

  getSettings() async {
    final dbInstance = DB();
    tip = await dbInstance.getTipSetting() ?? 15;
    tipController.text = tip.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip calculator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextFormField(
                      controller: amountController,
                      labelText: 'Amount',
                      hintText: 'Type the bill\'s total',
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
                    CustomTextFormField(
                      controller: poepleController,
                      labelText: 'People',
                      hintText: 'Type the number of people to divide the tip',
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
                    CustomTextFormField(
                      controller: tipController,
                      labelText: 'Tip percentage',
                      hintText: 'Type the bill\'s total',
                      enabled: false,
                    ),
                    ElevatedButton(
                      onPressed: (isErrorInFormAmount || isErrorInFormPeople)
                          ? null
                          : () {
                              billAmount = double.parse(amountController.text)
                                  .roundToDouble();
                              peopleForBill = int.parse(poepleController.text);
                              tipOfAmount = double.parse(
                                  (billAmount * (tip / 100))
                                      .toStringAsFixed(2));
                              totalAmount = billAmount + tipOfAmount;
                              personTip = double.parse(
                                  (totalAmount / peopleForBill)
                                      .toStringAsFixed(2));
                              FocusScope.of(context).requestFocus(FocusNode());
                              isResultVisible = true;
                              setState(() {});
                            },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calculate),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Calculate tip")
                          ]),
                    ),
                    ElevatedButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.replay_outlined),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Reset")
                          ]),
                      onPressed: () {
                        amountController.text = '';
                        poepleController.text = '';
                        billAmount = 0;
                        peopleForBill = 0;
                        tipOfAmount = 0;
                        totalAmount = 0;
                        personTip = 0;
                        isResultVisible = false;
                        setState(() {});
                      },
                    ),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Visibility(
                visible: isResultVisible,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.indigo[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Text(
                          'Bill\'s amount \$$billAmount',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Tip \$$tipOfAmount',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Num. of people: $peopleForBill',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Each person will pay: \$$personTip',
                          style: textStyle,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Total to pay \$$totalAmount',
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
