import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/Tether.dart';
import '../../../riverpods/read/tether_page_provider.dart';
import '../../components/gap.dart';

import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

class TetherPage extends StatefulWidget {
  final DocumentReference doc;
  TetherPage({
    Key key,
    @required this.doc,
  }) : super(key: key);

  @override
  _TetherPageState createState() => _TetherPageState();
}

class _TetherPageState extends State<TetherPage> {
  QuillController textController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, watch, child) {
          final state = watch(tetherPageStateProvider(widget.doc));
          if (state is TetherPageInitial) {
            return Container(
              height: sx * 100,
              width: sy * 100,
            );
          } else if (state is TetherPageLoading) {
            return Container(
              height: sx * 75,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is TetherPageLoaded) {
            textController.dispose();
            textController = QuillController(
              document: Document.fromJson(jsonDecode(state.tether.content)),
              selection: const TextSelection.collapsed(offset: 0),
            );
            return _content(state.tether);
          } else {
            return Center(child: Text('An unexpected error occured.'));
          }
        },
      ),
    );
  }

  Padding _content(Tether tether) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sy * 4),
      child: Column(
        children: [
          Gap(height: 5),
          Text(
            tether.title,
            textAlign: TextAlign.center,
            style: TetheredTextStyles.authSubHeading.copyWith(
              color: TetheredColors.readingPageTitle,
            ),
          ),
          Gap(height: 5),
          // Wrap(
          //   alignment: WrapAlignment.center,
          //   children: [
          //     BookDetailsInfoText(
          //       icon: Icons.visibility,
          //       text: '21M views',
          //       color: TetheredColors.readingPageInfo,
          //     ),
          //     BookDetailsInfoText(
          //       icon: Icons.arrow_upward,
          //       text: '12K upvotes',
          //       color: TetheredColors.readingPageInfo,
          //     ),
          //     BookDetailsInfoText(
          //       icon: Icons.list,
          //       text: '21 Tethers',
          //       color: TetheredColors.readingPageInfo,
          //     ),
          //   ],
          // ),
          Text(
            tether.description,
          ),
          Gap(height: 5),
          QuillEditor(
            controller: textController,
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: FocusNode(),
            autoFocus: true,
            readOnly: true,
            expands: false,
            padding: EdgeInsets.zero,
            showCursor: false,
          ),
          Gap(height: 5),
        ],
      ),
    );
  }
}
