import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  QuillController _controller = new QuillController.basic();

  final FocusNode _editorFocusNode = new FocusNode();

  bool dataLoaded = false;

  bool busySaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!dataLoaded) {
      dataLoaded = true;
      _controller.addListener(() {
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
        centerTitle: true,
        backgroundColor: TetheredColors.textFieldBackground,
        title: Text('Editor'),
      ),
      body: WillPopScope(
        onWillPop: () async {
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
              _controller = new QuillController(
                document: Document.fromDelta(state.content),
                selection: const TextSelection.collapsed(offset: 0),
              );
              return _editor(context);
            } else {
              return Center(child: Text('Please try again'));
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
}
