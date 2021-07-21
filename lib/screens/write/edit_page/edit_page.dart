import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final QuillController _controller = new QuillController.basic();
  final FocusNode _editorFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: TetheredColors.textFieldBackground,
        title: Text('Editor'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: sy * 3, vertical: sx * 2),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    super.dispose();
  }
}
