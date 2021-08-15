import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart' as FlutterBase;
import 'package:tethered/riverpods/global/user_provider.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/enums/tab_item.dart';
import 'package:tethered/utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tethered/utils/url_to_file.dart';

class EditProfilePage extends HookWidget {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditProfilePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = useProvider(userProvider);
    final userNotifier = useProvider(userProvider.notifier);
    final nameController = useTextEditingController(text: user.name);
    final usernameController = useTextEditingController(text: user.username);
    final descriptionController =
        useTextEditingController(text: user.description);
    final imageFile = useState<File>(null);
    final uploading = useState<bool>(false);
    useEffect(
      () {
        urlToFile(user.imageUrl).then((file) => imageFile.value = file);
        return;
      },
      [],
    );
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: TetheredColors.primaryDark,
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: uploading.value
                ? null
                : () async {
                    if (_formKey.currentState.validate()) {
                      uploading.value = true;
                      Reference ref;
                      if (imageFile.value != null) {
                        if (!user.imageUrl.isEmpty) {
                          ref = await FirebaseStorage.instance
                              .refFromURL(user.imageUrl);
                        } else {
                          ref = await FirebaseStorage.instance
                              .ref('accounts/${user.uid}/profile/profile.png');
                        }
                        await ref.putFile(imageFile.value);
                      }
                      print('Success');
                      await FirebaseFirestore.instance
                          .collection('accounts')
                          .doc(user.uid)
                          .update({
                        "name": nameController.text,
                        "username": usernameController.text,
                        "description": descriptionController.text,
                        "imageUrl": await ref?.getDownloadURL() ?? ''
                      });
                      userNotifier.getUserData(user.uid);
                      try {
                        Get.back(
                            id: tabItemsToIndex[
                                FlutterBase.Provider.of<TabItem>(context,
                                    listen: false)]);
                      } catch (e) {
                        Get.back();
                      }
                    }
                  },
            child: Text('Save'),
          ),
        ],
      ),
      body: uploading.value
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
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
                        'Name',
                        style: TetheredTextStyles.bookDetailsHeading,
                      ),
                      Gap(height: 2),
                      InputFormField(
                        hintText: 'Name',
                        controller: nameController,
                        validator: TextValidators.title,
                      ),
                      Gap(height: 4),
                      Text(
                        'Username',
                        style: TetheredTextStyles.bookDetailsHeading,
                      ),
                      Gap(height: 2),
                      InputFormField(
                        hintText: 'Username',
                        controller: usernameController,
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
                        'Cover Image',
                        style: TetheredTextStyles.bookDetailsHeading,
                      ),
                      Gap(height: 1),
                      Text(
                        'Aspect Ratio - 1:1',
                        style: TetheredTextStyles.subheadingText,
                      ),
                      Gap(height: 2),
                      imageFile.value == null
                          ? Container()
                          : Container(
                              width: sy * 50,
                              height: sy * 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(imageFile.value),
                                ),
                              ),
                            ),
                      imageFile.value == null ? Container() : Gap(height: 3),
                      ProceedButton(
                        text: 'Select Image',
                        onPressed: () async {
                          final imageSource = await _getImageSource(context);
                          if (imageSource == null) return;
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          FocusScope.of(context).requestFocus(new FocusNode());
                          XFile image = await _picker.pickImage(
                            source: imageSource,
                          );

                          if (image != null) {
                            File croppedFile = await ImageCropper.cropImage(
                              cropStyle: CropStyle.circle,
                              iosUiSettings: IOSUiSettings(
                                rotateButtonsHidden: true,
                              ),
                              sourcePath: image.path,
                              aspectRatio:
                                  CropAspectRatio(ratioX: 1, ratioY: 1),
                            );
                            if (croppedFile != null) {
                              imageFile.value = File(croppedFile.path);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
                try {
                  Get.back(
                    id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                        context,
                        listen: false)],
                  );
                } catch (e) {
                  Get.back();
                }
              },
            ),
            ListTile(
              title: Text('Gallery'),
              leading: Icon(Icons.image),
              onTap: () {
                source = ImageSource.gallery;
                try {
                  Get.back(
                    id: tabItemsToIndex[FlutterBase.Provider.of<TabItem>(
                        context,
                        listen: false)],
                  );
                } catch (e) {
                  Get.back();
                }
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
