class LoginResponse {
  int? resultCode;
  String? resultDescription;

  LoginResponse({this.resultCode, this.resultDescription});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDescription = json['resultDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultDescription'] = resultDescription;
    return data;
  }
}
