import 'package:equatable/equatable.dart';

class JsonResponse extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final Object? data;

  const JsonResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory JsonResponse.success({String message = 'success', Object? data}) =>
      JsonResponse(
        success: true,
        statusCode: 200,
        message: message,
        data: data,
      );

  factory JsonResponse.failure(
          {int statusCode = 500, String message = 'failure', Object? data}) =>
      JsonResponse(
        success: false,
        statusCode: statusCode,
        message: message,
        data: data,
      );

  factory JsonResponse.fromJson(Map<String, dynamic> json) => JsonResponse(
        success: json['success'] ?? false,
        statusCode: json['code'] ?? 500,
        message: json['message'] ?? 'something went wrong!',
        data: json['data'],
      );

  JsonResponse copyWith(
          {bool? success, int? statusCode, String? message, Object? data}) =>
      JsonResponse(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': statusCode,
        'message': message,
        'data': data,
      };

  @override
  List<Object> get props => [success, statusCode, message];

  @override
  String toString() =>
      'JsonResponse { success: $success, statusCode: $statusCode, message: $message, data: $data }';
}
