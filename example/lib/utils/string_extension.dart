import 'package:clear_notification_example/utils/import_utils_class_package.dart';

extension StringExtn on String {
  // bool isValidEmail() {
  //   return RegExp(
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
  //       .hasMatch(this);
  // }
  //
  // bool isValidTurkishCitizenshipNo() {
  //   return RegExp(r'^[1-9][0-9]{10}$').hasMatch(this);
  // }
  //
  // bool isValidPassportNo() {
  //   return RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(this);
  // }

  RemoteMessage? toRemoteMessage() {
    try {
      Map<String, dynamic> msgMap = jsonDecode(this);
      RemoteMessage msg = RemoteMessage.fromMap(msgMap);
      return msg;
    }
    catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  String removeAllWhiteSpace() {
    return replaceAll(' ', '');
  }

  String removePrefixWhiteSpace() {
    if (isNotEmpty && this[0] == ' ') {
      var newStr = substring(1);
      return newStr.removePrefixWhiteSpace();
    }
    return this;
  }

  String removeSuffixWhiteSpace() {
    if (isNotEmpty && this[length-1] == ' ') {
      var newStr = substring(0, length-1);
      return newStr.removeSuffixWhiteSpace();
    }
    return this;
  }

  String removePrefixSuffixWhiteSpace() {
    var newStr = removePrefixWhiteSpace();
    newStr = newStr.removeSuffixWhiteSpace();
    return newStr;
  }

  // bool isToReleasedForTransit() {
  //   return this == 'DECLARATION_GROUP_RELEASED_FOR_TRANSIT' ||
  //       this == 'DECLARATION_GROUP_ALL_RELEASED_FOR_TRANSIT';
  // }
}

extension NullableStringExtn on String? {
  bool hasValue() {
    if (this == null) {
      return false;
    }
    return true;
  }

  String nonNullValue() {
    if (!hasValue()) {
      return '';
    }
    if (this!.isEmpty) {
      return '';
    }
    if (this!.removeAllWhiteSpace().isEmpty) {
      return '';
    }
    return this!.removePrefixSuffixWhiteSpace();
  }
}