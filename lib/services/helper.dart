
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
          (Route<dynamic> route) => predict);
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24
            ),
          ),
        ),
      );
}

showSnackBarSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24
          ),
        ),
      ),
    );
}


String? validateUsername(String? value) {
  String pattern =
      r'^[A-Za-z][A-Za-z0-9_]{2,29}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value ?? '')) {
    return 'Enter Valid Username';
  } else {
    return null;
  }
}

String? validateCommonField(String? value) {
  String pattern =
      r'^[A-Za-z][A-Za-z0-9_]{2,29}$';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(value ?? '')) {
    return 'Enter valid value';
  } else {
    return null;
  }
}

InputDecoration getInputDecoration(
    {required String hint, required bool darkMode, required Color errorColor,  Icon? prefixIcon, Padding? suffixIcon, TextStyle? hintStyle}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    hintStyle: hintStyle,
    suffixIcon: suffixIcon,
    constraints: const BoxConstraints(maxWidth: 720, minWidth: 200),
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    fillColor: darkMode ? Colors.white : Colors.white,
    hintText: hint,
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.tealAccent, width: 2.0)),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) {
    return 'Password must be more than 5 characters';
  } else {
    return null;
  }
}



bool isDarkMode(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return false;
  } else {
    return true;
  }
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

late ProgressDialog progressDialog;
showProgress(BuildContext context, String message, bool isDismissible) async {
  progressDialog = ProgressDialog(context,
  type: ProgressDialogType.normal, isDismissible: isDismissible);
  progressDialog.style(
    message: message,
    borderRadius: 10.0,
    backgroundColor: const Color(0xFF151026),
    progressWidget: Container(
      padding: const EdgeInsets.all(8.0),
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.brown),
      ),
    ),
    elevation: 10.0,
    insetAnimCurve: Curves.easeInOut,
    messageTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 19.0,
      fontWeight: FontWeight.w600
    )
  );
  await progressDialog.show();
}

updateProgress(String message) {
  progressDialog.update(message: message);
}

hideProgress() async {
  await progressDialog.hide();
}