import 'package:dio/dio.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/globals.dart';

String handleDioError(Exception error) {
  String errorDescription = "";
  if (error is DioError) {
    DioError dioError = error;
    switch (dioError.type) {
      case DioErrorType.cancel:
        // errorDescription = "Request to API server was cancelled";
        errorDescription = S.of(localeContext).network_cancel;
        break;
      case DioErrorType.cancel:
        // errorDescription = "Connection timeout with API server";
        errorDescription = S.of(localeContext).network_connection_timeout;
        break;
      case DioErrorType.connectTimeout:
        // errorDescription = "Connection timeout with API server";
        errorDescription = S.of(localeContext).network_connection_timeout;
        break;
      case DioErrorType.other:
        // errorDescription =
        //     "Connection to API server failed due to internet connection";
        errorDescription = S.of(localeContext).network_default;
        break;
      case DioErrorType.receiveTimeout:
        // errorDescription = "Receive timeout in connection with API server";
        errorDescription = S.of(localeContext).network_receive_timeout;
        break;
      case DioErrorType.response:
        // errorDescription =
        //     "Received invalid status code: ${dioError.response.statusCode}";
        errorDescription =
            S.of(localeContext).network_response(dioError.response.statusCode);
        break;
      case DioErrorType.sendTimeout:
        // errorDescription = "Send timeout in connection with API server";
        errorDescription = S.of(localeContext).network_send_timeout;
        break;
    }
  } else {
    errorDescription = S.of(localeContext).some_error_occured;
  }
  return errorDescription;
}
