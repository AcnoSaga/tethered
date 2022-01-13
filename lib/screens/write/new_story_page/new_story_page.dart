import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:tethered/screens/components/validators/text_validators.dart';
import '../../../models/category_lists.dart';
import '../../../riverpods/write/new_story_page_provider.dart';
import '../../components/gap.dart';
import '../../components/input_form_field.dart';
import '../../components/proceed_button.dart';
import '../../components/widgets/book_details_tag.dart';
import 'components/genre_dropdown_input.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/enums/resource_types.dart';
import '../../../utils/enums/tab_item.dart';
import '../../../utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class NewStoryPage extends HookWidget {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final imageFile = useState<File>(null);
    final hashtags = useState<List<String>>([]);
    final genre = useState<String>(null);
    final state = useProvider(newStoryPageStateProvider);
    final uploading = useState<bool>(false);
    return WillPopScope(
      onWillPop: () async {
        return !uploading.value;
      },
      child: Scaffold(
        backgroundColor: TetheredColors.primaryDark,
        appBar: AppBar(
          brightness: Brightness.dark,
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
              return Form(
                key: _formKey,
                child: uploading.value
                    ? Center(child: CircularProgressIndicator())
                    : _createStoryDataInputs(context, hashtags, genre,
                        imageFile, state.categoryLists, uploading),
              );
            } else {
              return Center(
                child: Text(
                  'An unexpected error occured.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }(),
        ),
      ),
    );
  }

  Widget _createStoryDataInputs(
      BuildContext context,
      ValueNotifier<List<String>> hashtags,
      ValueNotifier<String> genre,
      ValueNotifier<File> imageFile,
      CategoryLists categoryLists,
      ValueNotifier<bool> uploading) {
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
              controller: titleController,
              validator: TextValidators.title,
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
              controller: descriptionController,
              validator: TextValidators.description,
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
              onSelect: (genreName) {
                genre.value = genreName;
              },
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
                      onLongPress: () =>
                          hashtags.value = [...hashtags.value]..remove(str),
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
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                FocusScope.of(context).requestFocus(new FocusNode());
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
              onPressed: () async {
                if (!_formKey.currentState.validate() ||
                    imageFile.value == null ||
                    genre.value == null) return;

                uploading.value = true;

                final uid = FirebaseAuth.instance.currentUser.uid;
                final workRef = FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(uid)
                    .collection('drafts')
                    .doc();

                try {
                  final ref = FirebaseStorage.instance.ref(
                      'accounts/' + uid + '/drafts/' + workRef.id + '.png');

                  await ref.putFile(imageFile.value);

                  await workRef.set({
                    "content": '[{"insert":"\\n"}]',
                    "description": descriptionController.text,
                    "genre": categoryLists.genres
                        .where((map) => map["name"] == genre.value)
                        .first["id"],
                    "hashtags": hashtags.value,
                    "imageUrl": await ref.getDownloadURL(),
                    "isTether": false,
                    "lastUpdated": Timestamp.now(),
                    "title": titleController.text,
                  });
                  await Get.dialog(
                    AlertDialog(
                      title: Text('Success 🥳'),
                      content: Text(
                          'Draft has been created.\n\nYou can find it in the Write tab\nGet Tethering!'),
                    ),
                  );
                } catch (e) {
                  Get.back(
                      id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                          context,
                          listen: false)]);
                  await Get.dialog(
                    AlertDialog(
                      title: Text('Error ❌'),
                      content: Text('Draft could not be created.'),
                    ),
                  );
                  print(e);
                }
                uploading.value = false;
                Get.back(
                  id: tabItemsToIndex[
                      FlutterBase.Provider.of<TabItem>(context, listen: false)],
                );
              },
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
