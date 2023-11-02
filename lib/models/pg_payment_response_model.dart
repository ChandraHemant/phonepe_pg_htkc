import 'dart:convert';

PGPaymentResponse paymentResponseFromJson(String str) => PGPaymentResponse.fromJson(json.decode(str));

class PGPaymentResponse {
  final bool success;
  final String code;
  final String message;
  final PaymentData data;

  PGPaymentResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PGPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PGPaymentResponse(
      success: json['success'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      data: PaymentData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PaymentData {
  final String merchantId;
  final String merchantTransactionId;
  final InstrumentResponse instrumentResponse;

  PaymentData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      merchantId: json['merchantId'] as String,
      merchantTransactionId: json['merchantTransactionId'] as String,
      instrumentResponse: InstrumentResponse.fromJson(
          json['instrumentResponse'] as Map<String, dynamic>),
    );
  }
}

class InstrumentResponse {
  final String type;
  final RedirectInfo redirectInfo;

  InstrumentResponse({
    required this.type,
    required this.redirectInfo,
  });

  factory InstrumentResponse.fromJson(Map<String, dynamic> json) {
    return InstrumentResponse(
      type: json['type'] as String,
      redirectInfo:
      RedirectInfo.fromJson(json['redirectInfo'] as Map<String, dynamic>),
    );
  }
}

class RedirectInfo {
  final String url;
  final String method;

  RedirectInfo({
    required this.url,
    required this.method,
  });

  factory RedirectInfo.fromJson(Map<String, dynamic> json) {
    return RedirectInfo(
      url: json['url'] as String,
      method: json['method'] as String,
    );
  }
}