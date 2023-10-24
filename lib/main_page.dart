import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_practise/provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider);
    final familyPostalCode =
        ref.watch(apiFamilyProvider(ref.watch(postalCodeProvider)));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (text) => onPostalCodeChanged(ref, text),
              ),
              Expanded(
                child: familyPostalCode.when(
                  data: (data) => ListView.separated(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.data[index].en.prefecture),
                          Text(data.data[index].en.address1),
                          Text(data.data[index].en.address2),
                          Text(data.data[index].en.address3),
                          Text(data.data[index].en.address4),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                    ),
                  ),
                  error: (error, _) => Text(error.toString()),
                  loading: () => const AspectRatio(
                      aspectRatio: 1, child: CircularProgressIndicator()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPostalCodeChanged(WidgetRef ref, String text) {
    if (text.length != 7) {
      return;
    }
    try {
      int.parse(text);
      ref.read(postalCodeProvider.notifier).state = text;
      print(text);
    } catch (ex) {}
  }
}
