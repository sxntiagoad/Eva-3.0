import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/preoperacional.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<Preoperacional>> getAllPreoperacionales() async {
  try {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    //QuerySnapshot<Map<String, dynamic>>
    final querySnapshot = await FirebaseFirestore.instance
        .collection('preoperacionales')
        .where('userId', isEqualTo: userId)
        .where('isOpen', isEqualTo: true)
        .get();


    List<Preoperacional> preoperacionales = querySnapshot.docs.map((doc) {
      return Preoperacional.fromMap(doc.data()).copyWith(docId: doc.id);
    }).toList();

    return preoperacionales;
  } catch (e) {
    rethrow;
  }
}

final allPreoperacionalesProvider =
    FutureProvider.autoDispose<List<Preoperacional>>((ref) async {
  return await getAllPreoperacionales();
});
