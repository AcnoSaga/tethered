import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'FirebaseDataGenre.dart';

// final listProvider = Provider<List<String>>((_create) {
//   // We will add firebase here
//   return [
//     "Top Picks",
//     "Horror",
//     "Romance",
//     "Comedy",
//   ];
// });

final FirebaseDataProvider = Provider((_create) => getFirebaseData());

final ResponseProvider = FutureProvider((ref) async {
  final dataClient = ref.watch(FirebaseDataProvider);
  return dataClient.getData();
});

class Riverpod_Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ButtonPage(),
    );
  }
}

// ignore: camel_case_types
class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Get Data'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataPage()),
            );
          },
        ),
      ),
    );
  }
}

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, watch, child) {
            final getListData = watch(ResponseProvider);
            return getListData.map(
                data: (_) => Text(getListData.toString()),
                loading: (_) => CircularProgressIndicator(),
                error: (_) => Text(
                      _.error.toString(),
                      style: TextStyle(color: Colors.red),
                    ));
          },
        ),
      ),
    );
  }
}
