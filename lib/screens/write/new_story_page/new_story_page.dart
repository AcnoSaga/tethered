import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/write/new_story_page/components/genre_dropdown_input.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewStoryPage extends StatefulWidget {
  @override
  _NewStoryPageState createState() => _NewStoryPageState();
}

class _NewStoryPageState extends State<NewStoryPage> {
  final ImagePicker _picker = ImagePicker();
  bool isMature = false;
  File imageFile;

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
                      value: isMature,
                      onChanged: (value) => setState(
                        () => isMature = value,
                      ),
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
                imageFile == null ? Container() : Image.file(imageFile),
                imageFile == null ? Container() : Gap(height: 3),
                ProceedButton(
                  text: 'Select Image',
                  onPressed: () async {
                    final imageSource = await _getImageSource();
                    if (imageSource == null) return;

                    XFile image = await _picker.pickImage(
                      source: imageSource,
                    );

                    if (image != null) {
                      File croppedFile = await ImageCropper.cropImage(
                        sourcePath: image.path,
                        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
                      );
                      if (croppedFile != null) {
                        setState(() {
                          imageFile = File(croppedFile.path);
                        });
                      }
                    }
                  },
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

  Future<ImageSource> _getImageSource() async {
    ImageSource source;
    await showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        builder: (BuildContext context) => ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Camera'),
              leading: Icon(Icons.camera),
              onTap: () {
                Get.back();
                source = ImageSource.camera;
              },
            ),
            ListTile(
              title: Text('Gallery'),
              leading: Icon(Icons.image),
              onTap: () {
                Get.back();
                source = ImageSource.gallery;
              },
            ),
          ],
        ),
        onClosing: () {},
      ),
    );
    return source;
  }
}
