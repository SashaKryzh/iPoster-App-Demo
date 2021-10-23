// ignore: camel_case_types
class iPosterResponse {
  final bool success;
  final String message;
  final dynamic data;

  iPosterResponse({this.success, this.message, this.data});

  factory iPosterResponse.fromJson(Map<String, dynamic> json,
      {Function(Map<String, dynamic> json) dataParser}) {
    return iPosterResponse(
      success: json['success'] as bool,
      message: json['message'],
      data: dataParser != null ? dataParser(json) : null,
    );
  }
}
