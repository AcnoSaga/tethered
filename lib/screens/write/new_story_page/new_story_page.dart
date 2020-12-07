import 'package:flutter/material.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/write/new_story_page/components/genre_dropdown_input.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class NewStoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Text(
          'Create New Story',
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
                  hintText: 'Untitled Story',
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
                Text(
                  'Genre',
                  style: TetheredTextStyles.bookDetailsHeading,
                ),
                Gap(height: 2),
                GenreDropdownInput(),
                Gap(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mature',
                      style: TetheredTextStyles.bookDetailsHeading,
                    ),
                    Switch.adaptive(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                Gap(height: 4),
                Text(
                  'Cover Image',
                  style: TetheredTextStyles.bookDetailsHeading,
                ),
                Gap(height: 1),
                Text(
                  'Aspect Ratio - 8:5',
                  style: TetheredTextStyles.subheadingText,
                ),
                Gap(height: 2),
                ProceedButton(
                  text: 'Select Image',
                  onPressed: () {},
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
