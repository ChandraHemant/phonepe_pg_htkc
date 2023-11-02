import 'package:example/controllers/pg_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo PhonePe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo PhonePe PG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(PGPaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Obx(()=> Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'PhonePe Payment Gateway Integration',
              ),
              MaterialButton(
                onPressed: (){
                  controller.initPayment(customerMobile: '+919876543210', amount: 100);
                },
                color: greenColor,
                child: Text(
                  'Pay Now',
                  style: boldTextStyle(color: white),
                ),
              ),
              50.height,
              Visibility(
                visible: !controller.isVisible.value,
                child: MaterialButton(
                  onPressed: (){
                    controller.checkPaymentStatus();
                  },
                  color: greenColor,
                  child: Text(
                    'Check Status',
                    style: boldTextStyle(color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
