import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

class getFirebaseData {
  Future<String> getData() async {
//     firestoreInstance
//         .collection("Genre")
//         .doc("HiIJXl9XWXS5bWUADUb1")
//         .get()
//         .then((querySnapshot) {
//       try {
//         final List<String> rdata =
//             List.castFrom(querySnapshot.data() as List ?? []);
//         print(rdata.join(" "));
//         return rdata.join(" ");
//       } catch (e) {
//         print(e);
//         return null;
//       }
//       // print(querySnapshot);
//       // // querySnapshot.docs.forEach((result) {
//       // //   returnedData.add(result.data().toString());
//       // // });
//     });

    final returnedDoc =
        firestoreInstance.collection('Genre').doc('HiIJXl9XWXS5bWUADUb1');
    return returnedDoc.snapshots().join(" ");
  }
}
