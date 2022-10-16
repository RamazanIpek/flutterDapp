import 'package:flutter/material.dart';
import 'package:simpleflutterdapp/models/ethereum_utils.dart';
import 'package:simpleflutterdapp/widgets/button_container_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MyHomePage extends StatefulWidget {
  @override
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EthereumUtils ethUtils = EthereumUtils();
  double? _value = 0.0;

  var _data;

  @override
  void initState() {
    ethUtils.initial();
    ethUtils.getBalance().then((value) {
      setState(() {
        _data = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Flutter DApp'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        const Text(
                          "Your Balance",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _data == null
                            ? CircularProgressIndicator()
                            : Text(
                                "${_data}",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SfSlider(
              value: _value,
              onChanged: (dynamic value) {
                setState(() {
                  _value = value;
                });
              },
              min: 0.0,
              max: 100.0,
              interval: 10.0,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              stepSize: 10.0,
              minorTicksPerInterval: 1,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            const SizedBox(
              height: 50,
            ),
            CustomContainerButtonWidget(
                title: "Get Balance",
                color: Colors.blue,
                onTap: () async {
                  ethUtils.getBalance().then((value) {
                    setState(() {
                      _data = value;
                    });
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            CustomContainerButtonWidget(
                title: "Send Balance",
                color: Colors.green,
                onTap: () async {
                  await ethUtils.sendBalance(_value!.toInt());
                  if (_value == 0) {
                    incorrectValueDialogBox(context);
                  } else {
                    sendDialogBox(context);
                  }
                }),
            const SizedBox(
              height: 50,
            ),
            CustomContainerButtonWidget(
                title: "Withdraw Balance",
                color: Colors.red,
                onTap: () async {
                  await ethUtils.withdrawBalance(_value!.toInt());
                  if (_value == 0) {
                    incorrectValueDialogBox(context);
                  } else {
                    withDrawDialogBox(context);
                  }
                }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  incorrectValueDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Incorrect Value"),
            content: const Text("Please enter a value greater than 0"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  sendDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Successful transaction"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  withDrawDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Successful Withdraw"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }
}
