import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_practise/data/postal_code.dart';
import 'package:future_provider_practise/main_logic.dart';

final _logicProvider = Provider((ref) => Logic());
final _postalCodeProvider = StateProvider((ref) => '');
final AutoDisposeFutureProviderFamily<PostalCode, String> _apiFamilyProvider =
    FutureProvider.autoDispose
        .family<PostalCode, String>((ref, postalCode) async {
  Logic logic = ref.watch(_logicProvider);
  if (!logic.willProceed(postalCode)) {
    return PostalCode.empty;
  }
  return await logic.getPostalCode(postalCode);
});

class MainPageVM {
  late final WidgetRef _ref;

  String get postalCode => _ref.watch(_postalCodeProvider);

  AsyncValue<PostalCode> postalCodeWithFamily(String post) =>
      _ref.watch(_apiFamilyProvider(postalCode));

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  void onPostalCodeChanged(String postalCode) {
    _ref.read(_postalCodeProvider.notifier).update((state) => postalCode);
  }
}
