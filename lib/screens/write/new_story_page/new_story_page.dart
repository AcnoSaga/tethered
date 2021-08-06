import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:tethered/models/catergory_lists.dart';
import 'package:tethered/riverpods/write/new_story_page_provider.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/widgets/book_details_tag.dart';
import 'package:tethered/screens/write/new_story_page/components/genre_dropdown_input.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/resource_types.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewStoryPage extends HookWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final imageFile = useState<File>(null);
    final hashtags = useState<List<String>>([]);
    final state = useProvider(newStoryPageStateProvider);

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
        child: () {
          if (state is NewStoryPageInitial) {
            return Container();
          } else if (state is NewStoryPageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewStoryPageLoaded) {
            return _createStoryDataInputs(
                context, hashtags, imageFile, state.categoryLists);
          } else {
            return Center(child: Text('Please try again'));
          }
        }(),
      ),
    );
  }

  Widget _createStoryDataInputs(
      BuildContext context,
      ValueNotifier<List<String>> hashtags,
      ValueNotifier<File> imageFile,
      CategoryLists categoryLists) {
    return SingleChildScrollView(
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
            ResourceDropdownInput(
              resourceType: ResourceTypes.genre,
              categoryList: categoryLists.genres
                  .map<String>((map) => map["name"])
                  .toList(),
            ),
            Gap(height: 4),
            GestureDetector(
              onTap: () => hashtags.value.add('#thriller'),
              child: Text(
                'Add Hashtag',
                style: TetheredTextStyles.bookDetailsHeading,
              ),
            ),
            Gap(height: 1),
            Wrap(
              spacing: sy * 5,
              runSpacing: sy * 2,
              children: hashtags.value
                  .map(
                    (str) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: BookDetailsTag(label: str),
                    ),
                  )
                  .toList(),
            ),
            Gap(height: 1),
            ResourceDropdownInput(
                resourceType: ResourceTypes.hashtag,
                categoryList: categoryLists.hashtags,
                onSelect: (value) {
                  if (!hashtags.value.contains(value))
                    hashtags.value = [...hashtags.value]..add(value);
                }),
            Gap(height: 4),
            Text(
              'Cover Image',
              style: TetheredTextStyles.bookDetailsHeading,
            ),
            Gap(height: 1),
            Text(
              'Aspect Ratio - 2:3',
              style: TetheredTextStyles.subheadingText,
            ),
            Gap(height: 2),
            imageFile.value == null ? Container() : Image.file(imageFile.value),
            imageFile.value == null ? Container() : Gap(height: 3),
            ProceedButton(
              text: 'Select Image',
              onPressed: () async {
                final imageSource = await _getImageSource(context);
                if (imageSource == null) return;

                XFile image = await _picker.pickImage(
                  source: imageSource,
                );

                if (image != null) {
                  File croppedFile = await ImageCropper.cropImage(
                    iosUiSettings: IOSUiSettings(
                      rotateButtonsHidden: true,
                    ),
                    sourcePath: image.path,
                    aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
                  );
                  if (croppedFile != null) {
                    imageFile.value = File(croppedFile.path);
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
    );
  }

  Future<ImageSource> _getImageSource(BuildContext context) async {
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
                source = ImageSource.camera;
                Get.back(
                  id: tabItemsToIndex[
                      FlutterBase.Provider.of<TabItem>(context, listen: false)],
                );
              },
            ),
            ListTile(
              title: Text('Gallery'),
              leading: Icon(Icons.image),
              onTap: () {
                source = ImageSource.gallery;
                Get.back(
                  id: tabItemsToIndex[
                      FlutterBase.Provider.of<TabItem>(context, listen: false)],
                );
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
