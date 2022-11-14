import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ApplicationHelper {
  static  ProgressDialog ? pr;
  static String? formDigits(int digits, String value) {
    String? finalDigits;
    switch (digits) {
      case 0:
        finalDigits = value;
        break;
      case 1:
        finalDigits = ("0" + value).substring(value.length);
        break;
      case 2:
        finalDigits = ("00" + value).substring(value.length);
        break;

      case 3:
        finalDigits = ("000" + value).substring(value.length);
        break;

      case 4:
        finalDigits = ("0000" + value).substring(value.length);
        break;

      case 5:
        finalDigits = ("00000" + value).substring(value.length);
        break;

      case 6:
        finalDigits = ("000000" + value).substring(value.length);
        break;

      case 7:
        finalDigits = ("0000000" + value).substring(value.length);
        break;

      case 8:
        finalDigits = ("00000000" + value).substring(value.length);
        break;

      case 9:
        finalDigits = ("000000000" + value).substring(value.length);
        break;
      case 10:
        finalDigits = ("0000000000" + value).substring(value.length);
        break;
      case 11:
        finalDigits = ("00000000000" + value).substring(value.length);
        break;
      case 12:
        finalDigits = ("000000000000" + value).substring(value.length);
        break;
      case 13:
        finalDigits = ("0000000000000" + value).substring(value.length);
        break;
    }
    return finalDigits;
  }

  static showProgressDialog(BuildContext context) async {
    /* Timer(
         const Duration(seconds: 60),
             () => dismissProgressDialog());*/
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: false);
    pr!.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr!.show();

  }

  static dismissProgressDialog() async {
    if(pr!.isShowing()) {
      pr!.hide();
    }
  }

  dateFormatter(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  timeFormatter(DateTime date) {
    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(date);
    return formatted;
  }

  timeFormatter2(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');
    final String formatted = formatter.format(date);
    return formatted;
  }

  dateFormatter1(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    final String formatted = formatter.format(date);
    return formatted;
  }

  dateFormatter4(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    return formatted;
  }


  dateFormatter2(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MMMM');
    final String formatted = formatter.format(date);
    return formatted;
  }

  stringtodate(String date) {
    final DateFormat formatter = DateFormat('yyyy - MMM');
    DateTime formatted = DateTime.parse(date);
    var convertedDate = formatter.format(formatted);
    return convertedDate;
  }
}