PhonePe PG HTKC is a reusable Flutter package that integrate PhonePe Payment Gateway in any Flutter project.

# Features

PhonePe payment gateway complete process for Flutter App with Payment Status.

## Other Features Laravel response logics

```php
    public function response(Request $request)
    {
        $input = $request->all();
        $saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';
        $saltIndex = 1;

        $finalXHeader = hash('sha256','/pg/v1/status/'.$input['merchantId'].'/'.$input['transactionId'].$saltKey).'###'.$saltIndex;

        $response = Curl::to('https://api.phonepe.com/apis/hermes/pg/v1/status/'.$input['merchantId'].'/'.$input['transactionId'])
                ->withHeader('Content-Type:application/json')
                ->withHeader('accept:application/json')
                ->withHeader('X-VERIFY:'.$finalXHeader)
                ->withHeader('X-MERCHANT-ID:'.$input['merchantId'])
                ->get();

        return $response;
    }
```

## Laravel initiate payment logics

```php
    
    public function phonePe()
    {
        $data = array (
          'merchantId' => 'PGTESTPAYUAT',
          'merchantTransactionId' => uniqid(),
          'merchantUserId' => 'MERCHANTUSERID1',
          'amount' => 100,
          'redirectUrl' => route('response'),
          'redirectMode' => 'POST',
          'callbackUrl' => route('response'),
          'mobileNumber' => '9999999999',
          'paymentInstrument' =>
          array (
            'type' => 'PAY_PAGE',
          ),
        );

        $encode = base64_encode(json_encode($data));

        $saltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';
        $saltIndex = 1;

        $string = $encode.'/pg/v1/pay'.$saltKey;
        $sha256 = hash('sha256',$string);

        $finalXHeader = $sha256.'###'.$saltIndex;

        $response = Curl::to('https://api.phonepe.com/apis/hermes/pg/v1/pay')
                ->withHeader('Content-Type:application/json')
                ->withHeader('X-VERIFY:'.$finalXHeader)
                ->withData(json_encode(['request' => $encode]))
                ->post();

        $rData = json_decode($response);

        return redirect()->to($rData->data->instrumentResponse->redirectInfo->url);

    }
```

# Getting started

Create your project and follow below instructions.

## Usage

[Example] (https://github.com/ChandraHemant/phonepe_pg_htkc/blob/main/example/)

To use this package : *add dependency to your [pubspec.yaml] file

```yaml
   dependencies:
     flutter:
       sdk: flutter
     phonepe_pg_htkc: 
```
## Add to your dart file

```dart
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

```

## Controller Logics

```dart
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:phonepe_pg_htkc/models/pg_payment_status_model.dart';
import 'package:phonepe_pg_htkc/phonepe_pg_htkc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PGPaymentController extends GetxController {
  var isLoading = false.obs;
  var isVisible = true.obs;
  var errorMsg = ''.obs;
  var merchantTransactionId = ''.obs;
  var paymentStatusResponse = List<PGPaymentStatusResponse>.empty().obs;
  Uuid uuid = const Uuid();


  void checkPaymentStatus() async {
    try {
      isLoading(true);
      var data = await PhonePeApiServices.checkTransactionStatus(merchantTransactionId.value);
      if (data != null) {
        if(data.code=='PAYMENT_SUCCESS'){
          toast('Payment Success!!');
        } else if(data.code=='PAYMENT_PENDING'){
          toast('Please complete payment process!!!');
        }  else if(data.code=='PAYMENT_ERROR'){
          isVisible(true);
          toast('Payment failed! Please try again!');
        }
      } else {
        isVisible(true);
        toast('Transaction failed! Please try again!');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> initPayment({
    required String customerMobile,
    required double amount}) async {
    merchantTransactionId.value = uuid.v1();
    try {
      isLoading(true);
      var paymentResponse = await PhonePeApiServices.initTransaction(merchantTransactionId.value, customerMobile, amount);
      if (paymentResponse != null) {
        await launchUrl(Uri.parse(paymentResponse.data.instrumentResponse.redirectInfo.url),mode: LaunchMode.externalNonBrowserApplication);
        isVisible(false);
        return true;
      } else {
        toast('Something went wrong! Please try again later');
        return true;
      }
    } finally {
      isLoading(false);
    }
  }

}

```

# Other instruction

This package is currently not working properly in flutter web