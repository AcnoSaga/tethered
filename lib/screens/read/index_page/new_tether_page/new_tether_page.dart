import 'package:flutter/material.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class NewTetherPage extends StatefulWidget {
  final BookDetails bookDetails;

  const NewTetherPage({Key key, this.bookDetails}) : super(key: key);
  @override
  _NewTetherPageState createState() => _NewTetherPageState();
}

class _NewTetherPageState extends State<NewTetherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Text(
          'Create New Tether',
          style: TetheredTextStyles.secondaryAppBarHeading,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sy * 5,
              vertical: sx * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TetheredTextStyles.bookDetailsHeading,
                ),
                Gap(height: 2),
                InputFormField(
                  hintText: 'Untitled Tether',
                ),
                Gap(height: 4),
                Text(
                  'Description',
                  style: TetheredTextStyles.bookDetailsHeading,
                ),
                Gap(height: 2),
                InputFormField(
                  hintText: 'Description',
                  maxLines: 10,
                  minLines: 2,
                ),
                Gap(height: 4),
                ProceedButton(
                  text: 'Create',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
