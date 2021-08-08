import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/services/firestore_service.dart';

class EditPageStateNotifier extends StateNotifier<EditPageState> {
  EditPageStateNotifier(DocumentReference docRef) : super(EditPageInitial()) {
    loadEditPageData(docRef);
  }

  FirestoreService _firestoreService = locator<FirestoreService>();

  void loadEditPageData(DocumentReference docRef) async {
    state = EditPageLoading();
    try {
      final delta = await _firestoreService.getEditPageData(docRef);
      if (delta == null) {
        throw Exception();
      }
      state = EditPageLoaded(content: delta);
    } catch (e) {
      print(e);
      state = EditPageError();
    }
  }
}

@immutable
abstract class EditPageState {}

class EditPageInitial extends EditPageState {}

class EditPageLoading extends EditPageState {}

class EditPageError extends EditPageState {}

class EditPageLoaded extends EditPageState {
  final Delta content;

  EditPageLoaded({this.content});
}

final editPageStateProvider = StateNotifierProvider.autoDispose
    .family<EditPageStateNotifier, EditPageState, DocumentReference>(
        (ref, docRef) {
  return EditPageStateNotifier(docRef);
});
