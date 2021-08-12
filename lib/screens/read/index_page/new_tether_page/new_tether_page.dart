import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/models/book_details.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> uploading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Text(
          'Create New Tether',
          style: TetheredTextStyles.secondaryAppBarHeading,
        ),
      ),
      body: uploading.value
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SafeArea(
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
                            controller: titleController,
                            validator: TextValidators.title),
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
                          controller: descriptionController,
                          validator: TextValidators.description,
                        ),
                        Gap(height: 4),
                        ProceedButton(
                          text: 'Create',
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) return;

                            uploading.value = true;

                            final uid = FirebaseAuth.instance.currentUser.uid;
                            final workRef = FirebaseFirestore.instance
                                .collection('accounts')
                                .doc(uid)
                                .collection('drafts')
                                .doc();

                            try {
                              await workRef.set({
                                "content": '[{"insert":"\n"}]',
                                "description": descriptionController.text,
                                "genre": widget.bookDetails.genre,
                                "hashtags": widget.bookDetails.hashtags,
                                "imageUrl": widget.bookDetails.imageUrl,
                                "isTether": true,
                                "lastUpdated": Timestamp.now(),
                                "title": titleController.text,
                                "workRef": widget.bookDetails.doc.reference,
                              });
                            } catch (e) {
                              // TODO: Manage error
                              Get.back();
                              print(e);
                            }
                            uploading.value = false;
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
