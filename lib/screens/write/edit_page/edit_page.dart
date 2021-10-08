import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/riverpods/global/app_busy_status_provider.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/utils/text_styles.dart';
import '../../../riverpods/write/editor_page_provider.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);
  final docSnapshot = Get.arguments["doc"] as DocumentSnapshot;
  final onDelete = Get.arguments["onDelete"] as Function;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  QuillController _controller = QuillController.basic();

  final FocusNode _editorFocusNode = FocusNode();

  bool dataLoaded = false;

  bool busySaving = false;

  final uploading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    print(busySaving);

    _controller.changes.listen((event) {
      print(busySaving);
      if (!busySaving) {
        busySaving = true;
        Future.delayed(Duration(seconds: 10)).then((_) async {
          print('Sahi hai');
          print(widget.docSnapshot.id);
          await _saveContent(isLengthEnforced: false);
          busySaving = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: TetheredColors.textFieldBackground,
        title: Text('Editor'),
        actions: [
          TextButton(
            child: Text('Submit'),
            onPressed: uploading.value
                ? null
                : () async {
                    final appBusyStatusNotifier =
                        context.read(appBusyStatusProvider.notifier);
                    await _submitDialog(appBusyStatusNotifier);
                  },
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (uploading.value) {
            return false;
          }
          await _saveContent(isLengthEnforced: false);
          widget.onDelete();
          return true;
        },
        child: SafeArea(
          child: Consumer(builder: (context, watch, child) {
            final state =
                watch(editPageStateProvider(widget.docSnapshot.reference));
            if (state is EditPageInitial) {
              return Container();
            } else if (state is EditPageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EditPageLoaded) {
              if (!dataLoaded) {
                dataLoaded = true;
                _controller.document
                    .compose(state.content, ChangeSource.REMOTE);
              }
              return _editor(context);
            } else {
              return Center(child: Text('An unexpected error occured.'));
            }
          }),
        ),
      ),
    );
  }

  Widget _editor(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sy * 3, vertical: sx * 2),
            child: Container(
              child: QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: _editorFocusNode,
                autoFocus: true,
                readOnly: false,
                expands: false,
                padding: EdgeInsets.zero,
                onTapUp: (tapUpDetails, _) {
                  // Show keyboard again after selecting image
                  FocusScope.of(context).requestFocus(FocusNode());
                  FocusScope.of(context).requestFocus();
                  return true;
                },
              ),
            ),
          ),
        ),
        QuillToolbar.basic(
          controller: _controller,
          showListCheck: false,
          showCamera: false,
          // onImagePickCallback: (file) async {
          //   final appDocDir = await getApplicationDocumentsDirectory();
          //   final copiedFile =
          //       await file.copy('${appDocDir.path}/${basename(file.path)}');
          //   return copiedFile.path.toString();
          // },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _saveContent({bool isLengthEnforced = false}) async {
    final docRef = widget.docSnapshot.reference;
    if (isLengthEnforced) {
      final textLength = _controller.plainTextEditingValue.text.length;
      if (textLength > 10000 || textLength < 100) {
        Get.snackbar('Save Unsuccessful',
            'The document should have at least 100 and at most 10,000 characters.',
            backgroundColor: Colors.white);
        return;
      }
    }
    if ((await docRef.get()).exists)
      await docRef.update({
        "content": jsonEncode(_controller.document.toDelta().toJson()),
        "lastUpdated": Timestamp.now(),
      });
  }

  Future _submitDialog(AppBusyStatusNotifier appBusyStatusNotifier) async {
    await _saveContent();
    print(_controller.plainTextEditingValue.text);
    final textLength = _controller.plainTextEditingValue.text.length;
    if (textLength > 10000 || textLength < 100) {
      Get.snackbar('Length Error',
          'The document should have at least 100 and at most 10,000 characters.',
          backgroundColor: Colors.white);
      return;
    }
    await Get.dialog(
      AlertDialog(
        title: Text(
            'Are you sure you want to submit this draft?\nThis action can not be reversed.'),
        actions: [
          TextButton.icon(
            onPressed: uploading.value
                ? null
                : () async {
                    appBusyStatusNotifier.startWork();
                    uploading.value = true;
                    try {
                      if (widget.docSnapshot['isTether'] == true) {
                        print(widget.docSnapshot.reference.path);
                        print(
                            (widget.docSnapshot['workRef'] as DocumentReference)
                                .path);
                        print(FirebaseAuth.instance.currentUser.uid);

                        await locator<FirestoreService>().submitDraft(
                          widget.docSnapshot.reference.path,
                          (widget.docSnapshot['workRef'] as DocumentReference)
                              .path,
                          FirebaseAuth.instance.currentUser.uid,
                        );
                      } else {
                        await locator<FirestoreService>().submitNewStory(
                          widget.docSnapshot.reference.path,
                          FirebaseAuth.instance.currentUser.uid,
                        );
                      }
                      uploading.value = false;

                      Get.back();
                      Get.back();
                      await Get.dialog(
                        AlertDialog(
                          title: Text('Success 🥳'),
                          content: Text('Draft has been submitted.'),
                        ),
                      );
                    } catch (e) {
                      Get.back();
                      await Get.dialog(
                        AlertDialog(
                          title: Text('Error ❌'),
                          content: Text('Draft could not be submitted.'),
                        ),
                      );
                    }

                    appBusyStatusNotifier.endWork();
                  },
            icon: Icon(
              Icons.check_circle,
              color: TetheredColors.acceptNegativeColor,
            ),
            label: Text(
              'Yes',
              style: TetheredTextStyles.acceptNegativeText,
            ),
          ),
          TextButton.icon(
            onPressed: uploading.value ? null : () => Get.back(),
            icon: Icon(
              Icons.cancel,
              color: TetheredColors.rejectNegativeColor,
            ),
            label: Text(
              'No',
              style: TetheredTextStyles.rejectNegativeText,
            ),
          ),
        ],
      ),
    );
    print('------------------------------');
    Get.back();
  }
}
