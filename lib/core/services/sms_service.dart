import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Fast2SmsResponse {
  final bool success;
  final String requestId;
  final List<String> message;

  Fast2SmsResponse({
    required this.success,
    required this.requestId,
    required this.message,
  });

  factory Fast2SmsResponse.fromJson(Map<String, dynamic> json) {
    return Fast2SmsResponse(
      success: json['return'] as bool,
      requestId: json['request_id'] as String,
      message: List<String>.from(json['message'] as List),
    );
  }
}

class SmsService {
  static const String _baseUrl = 'https://www.fast2sms.com/dev/bulkV2';
  final String _apiKey;

  SmsService() : _apiKey = dotenv.env['FAST2SMS_API_KEY'] ?? '';

  Future<Fast2SmsResponse> sendOtp(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'authorization': _apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'variables_values': otp,
          'route': 'otp',
          'numbers': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return Fast2SmsResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      throw Exception('Failed to send OTP');
    }
  }
}
