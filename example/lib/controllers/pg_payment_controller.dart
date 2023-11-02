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
