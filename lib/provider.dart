import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_practise/data/postal_code.dart';
import 'package:http/http.dart' as http;

StateProvider<String> postalCodeProvider = StateProvider((ref) => '');

FutureProvider<PostalCode> apiProvider = FutureProvider((ref) async {
  // 入力された郵便番号を取得
  final postalCode = ref.watch(postalCodeProvider);
  if (postalCode.length != 7) {
    throw Exception('Postal code must be 7 charactors');
  }

  // 123-4567
  final upper = postalCode.substring(0, 3);
  final lower = postalCode.substring(3);

  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';

  final apiUri = Uri.parse(apiUrl);
  http.Response response = await http.get(apiUri);

  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }

  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});

AutoDisposeFutureProviderFamily<PostalCode, String> apiFamilyProvider =
    FutureProvider.autoDispose
        .family<PostalCode, String>((ref, postalCode) async {
  if (postalCode.length != 7) {
    throw Exception('Postal code must be 7 charactors');
  }

  // 123-4567
  final upper = postalCode.substring(0, 3);
  final lower = postalCode.substring(3);

  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';

  final apiUri = Uri.parse(apiUrl);
  http.Response response = await http.get(apiUri);

  if (response.statusCode != 200) {
    throw Exception('No postal code: $postalCode');
  }

  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});
