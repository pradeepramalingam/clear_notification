import 'package:clear_notification_example/utils/import_utils_class_package.dart';

extension StringExtn on String {
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