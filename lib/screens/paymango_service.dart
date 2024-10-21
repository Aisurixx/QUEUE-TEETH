import 'package:http/http.dart' as http;
import 'dart:convert';

class PayMongoService {
  final String apiKey = 'sk_test_JwWDRviSQGg1qajfGmQhrVGN'; // Your PayMongo API key

  Future<String?> createPaymentIntent(double amount, String description) async {
    final String paymongoUrl = 'https://api.paymongo.com/v1/links';

    final response = await http.post(
      Uri.parse(paymongoUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'amount': (amount * 100).toInt(),
            'currency': 'PHP',
            'payment_method_allowed': ['gcash', 'card'],
            'description': description,
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data']['attributes']['checkout_url'];
    } else {
      print('Payment intent creation failed: ${response.body}');
      return null;
    }
  }

 Future<String?> createPayment(double amount, String description, String paymentMethodId, String paymentMethodType) async {
  final String paymongoUrl = 'https://api.paymongo.com/v1/payments';

  final response = await http.post(
    Uri.parse(paymongoUrl),
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'data': {
        'attributes': {
          'amount': (amount * 100).toInt(),
          'currency': 'PHP',
          'description': description,
          'source': {
            'id': paymentMethodId, // The payment method ID
            'type': paymentMethodType, // The payment method type (e.g., 'gcash', 'card')
          },
        },
      },
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData['data']['id']; // Return the payment ID
  } else {
    print('Payment creation failed: ${response.body}');
    throw Exception('Payment creation failed: ${response.body}');
  }
}



  Future<bool> checkPaymentStatus(String paymentId) async {
    final String paymongoPaymentUrl = 'https://api.paymongo.com/v1/payments/$paymentId';

    final response = await http.get(
      Uri.parse(paymongoPaymentUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data']['attributes']['status'] == 'paid';
    } else {
      print('Payment status check failed: ${response.body}');
      return false;
    }
  }
}
