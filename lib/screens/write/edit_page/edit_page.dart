import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/services/firestore_service.dart';
import 'package:tethered/utils/text_styles.dart';
import '../../../riverpods/write/editor_page_provider.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);
  final docSnapshot = Get.arguments as DocumentSnapshot;

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
    _controller.changes.listen((event) {
      print(_controller.plainTextEditingValue);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!dataLoaded) {
      dataLoaded = true;
      _controller.addListener(() {
        print(busySaving);
        if (!busySaving) {
          busySaving = true;
          Future.delayed(Duration(seconds: 3)).then((_) async {
            print('Sahi hai');
            print(widget.docSnapshot.id);
            await _saveContent();
            busySaving = false;
          });
        }
      });
    }
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
            onPressed: uploading.value ? null : () => _submitDialog(),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (uploading.value) {
            return false;
          }
          await _saveContent();
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
              _controller.dispose();
              _controller = QuillController(
                document: Document.fromDelta(state.content),
                selection: const TextSelection.collapsed(offset: 0),
              );
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
          onImagePickCallback: (file) async {
            final appDocDir = await getApplicationDocumentsDirectory();
            final copiedFile =
                await file.copy('${appDocDir.path}/${basename(file.path)}');
            return copiedFile.path.toString();
          },
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

  void _saveContent() async {
    final docRef = widget.docSnapshot.reference;
    print(_controller.document.toDelta().toJson());
    if (widget.docSnapshot.exists)
      await docRef.update({
        "content": jsonEncode(_controller.document.toDelta().toJson()),
        "lastUpdated": Timestamp.now(),
      });
  }

  Future _submitDialog() async {
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
                      Get.back();
                      Get.snackbar(
                        'Success 🥳',
                        'Draft has been submitted.',
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.white,
                      );
                    } catch (e) {
                      Get.back();
                      Get.snackbar(
                        'Error',
                        'Draft could not be created.',
                        backgroundColor: Colors.white,
                      );
                    }
                    uploading.value = false;
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
