class TopUpRequest {
  final String taId;
  final String taFname;
  final String taLname;
  final String taTopupAmt;
  final String taPayMode;
  final String? taChequeNo;
  final String? taChequeDate;
  final String? taBankName;
  final String? taTransactionId;
  final String taRefImg;

  TopUpRequest({
    required this.taId,
    required this.taFname,
    required this.taLname,
    required this.taTopupAmt,
    required this.taPayMode,
    this.taChequeNo,
    this.taChequeDate,
    this.taBankName,
    this.taTransactionId,
    required this.taRefImg,
  });

  Map<String, dynamic> toJson() => {
        'ta_id': taId,
        'ta_fname': taFname,
        'ta_lname': taLname,
        'ta_topup_amt': taTopupAmt,
        'ta_pay_mode': taPayMode,
        'ta_cheque_no': taChequeNo ?? '',
        'ta_cheque_date': taChequeDate ?? '',
        'ta_bank_name': taBankName ?? '',
        'ta_transaction_id': taTransactionId ?? '',
        'ta_ref_img': taRefImg,
      };
}
