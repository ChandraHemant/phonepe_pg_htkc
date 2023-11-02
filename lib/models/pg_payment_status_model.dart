import 'dart:convert';

PGPaymentStatusResponse paymentStatusResponseFromJson(String str) => PGPaymentStatusResponse.fromJson(json.decode(str));

String paymentStatusResponseToJson(PGPaymentStatusResponse data) => json.encode(data.toJson());

class PGPaymentStatusResponse {
  bool success;
  String code;
  String message;
  Data data;

  PGPaymentStatusResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PGPaymentStatusResponse.fromJson(Map<String, dynamic> json) => PGPaymentStatusResponse(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String merchantId;
  String merchantTransactionId;
  dynamic transactionId;
  int amount;
  dynamic state;
  dynamic responseCode;
  dynamic paymentInstrument;

  Data({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.transactionId,
    required this.amount,
    required this.state,
    required this.responseCode,
    required this.paymentInstrument,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    merchantId: json["merchantId"],
    merchantTransactionId: json["merchantTransactionId"],
    transactionId: json["transactionId"],
    amount: json["amount"],
    state: json["state"],
    responseCode: json["responseCode"],
    paymentInstrument: json["paymentInstrument"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "merchantTransactionId": merchantTransactionId,
    "transactionId": transactionId,
    "amount": amount,
    "state": state,
    "responseCode": responseCode,
    "paymentInstrument": paymentInstrument.toJson(),
  };
}

class PaymentInstrument {
  dynamic type;
  dynamic cardType;
  dynamic pgTransactionId;
  dynamic bankTransactionId;
  dynamic pgAuthorizationCode;
  dynamic arn;
  dynamic bankId;
  dynamic brn;

  PaymentInstrument({
    required this.type,
    required this.cardType,
    required this.pgTransactionId,
    required this.bankTransactionId,
    required this.pgAuthorizationCode,
    required this.arn,
    required this.bankId,
    required this.brn,
  });

  factory PaymentInstrument.fromJson(Map<String, dynamic> json) => PaymentInstrument(
    type: json["type"],
    cardType: json["cardType"],
    pgTransactionId: json["pgTransactionId"],
    bankTransactionId: json["bankTransactionId"],
    pgAuthorizationCode: json["pgAuthorizationCode"],
    arn: json["arn"],
    bankId: json["bankId"],
    brn: json["brn"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "cardType": cardType,
    "pgTransactionId": pgTransactionId,
    "bankTransactionId": bankTransactionId,
    "pgAuthorizationCode": pgAuthorizationCode,
    "arn": arn,
    "bankId": bankId,
    "brn": brn,
  };
}
