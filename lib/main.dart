// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    title: "WA Direct",
    home: const HomeScreen(),
    theme: ThemeData(primarySwatch: Colors.purple),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void launchwa(
    String number2,
    TextEditingController messageController,
    GlobalKey<ScaffoldState> globalKey,
    BuildContext context,
    String selectedCountry) async {
  //await canLaunch("https://wa.me/${number2}")?launch("https://wa.me/${number2}"): print("cant open");
  late SnackBar snackBar;
  if (number2.isEmpty || number2.length < 10) {
    snackBar = const SnackBar(content: Text("Enter Valid Mobile Number"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }
  if (kIsWeb) {
    await launch(
        "https://wa.me/${number2}?text=${messageController.text.toString()}");
  } else {
    await launch("whatsapp://send?phone=" +
        number2 +
        "&text=${messageController.text.toString()}");
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCountry = "+91";
  final TextEditingController number = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late String number2;

  late SnackBar snackBar;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Wa Direct Tool"),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.purple),
      ),
      body: Align(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            color: Colors.white,
            child: Center(
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: CountryCodePicker(
                            initialSelection: "IN",
                            favorite: const ["+91", "IN"],
                            onChanged: (item) {
                              print("county code: " + item.dialCode!);
                              setState(() {
                                selectedCountry = item.dialCode!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: number,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          maxLength: 25,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              hintText: "Mobile  Number",
                              labelText: "Mobile  Number",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          maxLength: 150,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Enter message to send",
                              labelText: "Enter message to send",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          number2 = selectedCountry + number.text.toString();

                          if (kIsWeb) {
                            launchwa(number2, _messageController, _globalKey,
                                context, selectedCountry);
                          } else {
                            launchwa(number2, _messageController, _globalKey,
                                context, selectedCountry);
                          }
                          // snackBar =
                          //     SnackBar(content: Text(number2.toString()));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Text("Send Message"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
