library phonepe_pg_htkc;

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:phonepe_pg_htkc/models/pg_payment_status_model.dart';
import 'package:phonepe_pg_htkc/models/pg_payment_response_model.dart';
import 'package:http/http.dart' as http;

class PhonePeApiVariables{
  /// PhonePe PG
  static const String request = 'request';
  static const String success = 'success';
  static const String merchantId = 'merchantId';
  static const String transactionId = 'transactionId';

}

class PhonePeApiStrings{

  static const String pgResponseUrl = "hemantchandra.com/pg/response";
  static const String prodPayResponse = '/phonepe/response';

  /// PhonePe PG URLs
  static const String pgProdUrl = "https://api.phonepe.com/apis/hermes";
  static const String pgUATUrl = "https://api-preprod.phonepe.com/apis/hermes";

  /// PhonePe PG Variables
  static const String prodPay = '/pg/v1/pay';
  static const String prodPayStatus = '/pg/v1/status';

  /// PhonePe PG UAT Variables
  static const String uatMerchantId = 'PGTESTPAYUAT';
  static const String uatSaltKey = '099eb0cd-02cf-4e2a-8aca-3e6c6aff0399';

}

class PhonePeApiServices {
  static var client = http.Client();

  /// PhonePe PG Initialize Payment
  static Future<PGPaymentResponse?> initTransaction(
      String merchantTransactionId,
      String customerMobile,
      double amount,{
        String merchantId = PhonePeApiStrings.uatMerchantId,
        String merchantUserId = '9999999999',
        String saltKey = PhonePeApiStrings.uatSaltKey,
        String saltIndex = '1',
        String redirectURL = 'https://${PhonePeApiStrings.pgResponseUrl}${PhonePeApiStrings.prodPayResponse}',
        String callBackURL = 'https://${PhonePeApiStrings.pgResponseUrl}${PhonePeApiStrings.prodPayResponse}',
        bool isUAT = true,
      }) async {
    Map<String, dynamic> body = {
      "merchantId": merchantId,
      "merchantTransactionId": merchantTransactionId,
      "merchantUserId": merchantUserId,
      "amount": amount,
      "redirectUrl": redirectURL,
      "callbackUrl": callBackURL,
      "mobileNumber": customerMobile,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64String = base64.encode(utf8.encode(jsonEncode(body)));
    String toEncodeToSha256 = '$base64String${PhonePeApiStrings.prodPay}$saltKey';
    final String sha256String =
    crypto.sha256.convert(utf8.encode(toEncodeToSha256)).toString();

    final String finalString = '$sha256String###$saltIndex';

    http.Response response = await http
        .post(Uri.parse((isUAT?PhonePeApiStrings.pgUATUrl:PhonePeApiStrings.pgProdUrl) + PhonePeApiStrings.prodPay),
        body: jsonEncode({
          PhonePeApiVariables.request: base64String,
        }),
        headers: setPGHeader(finalString));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      if (jsonMap[PhonePeApiVariables.success]) {
        return paymentResponseFromJson(jsonString);
      }
      return null;
    } else {
      return null;
    }
  }

  /// PhonePe PG Check Payment Status
  static Future<PGPaymentStatusResponse?> checkTransactionStatus(
      String merchantTransactionId,{
        String merchantId = PhonePeApiStrings.uatMerchantId,
        String pgResponseUrl = PhonePeApiStrings.pgResponseUrl,
        bool isUAT = true
      }) async {
    var response = await client.post(
        Uri.https(pgResponseUrl, PhonePeApiStrings.prodPayResponse), body: {
      PhonePeApiVariables.transactionId: merchantTransactionId,
      PhonePeApiVariables.merchantId: merchantId,
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      if (jsonMap[PhonePeApiVariables.success]) {
        return paymentStatusResponseFromJson(jsonString);
      }
      return null;
    } else {
      return null;
    }
  }

  static setPGHeader(String pgXVerify) {
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-VERIFY": pgXVerify,
      "Access-Control-Allow-Credentials": "true",
      'Access-Control-Allow-Origin': '*',
      "Access-Control-Allow-Methods": 'GET, DELETE, HEAD, OPTIONS',
      "Origin": 'api-preprod.phonepe.com',
    };
    return header;
  }
}
