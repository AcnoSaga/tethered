import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({Key key}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TetheredTextStyles.secondaryAppBarHeading,
        ),
        centerTitle: true,
        backgroundColor: TetheredColors.textFieldBackground,
      ),
      body: Padding(
        padding: EdgeInsets.all(sy * 5),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (s) => print(s),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    controller.clear();
                  }),
                  child: Text('POST'),
                ),
              ],
            ),
            Gap(height: 2),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  title: GestureDetector(
                    onTap: () => Get.toNamed('/account', arguments: {
                      "uid": null,
                    }),
                    child: Text('Aamish Ahmad Beg'),
                  ),
                  subtitle: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed leo massa, tempus in quam ut, mollis consectetur risus. Donec blandit sodales pulvinar. Sed non neque ipsum. Suspendisse condimentum nec sapien nec imperdiet. Aenean eu dictum nisl. Proin nec elementum odio, in ornare quam. Suspendisse et arcu purus. Etiam sit amet bibendum lacus. Nam eget felis vitae risus tincidunt vulputate. Sed vitae eros scelerisque, elementum dolor vel, venenatis ipsum. Curabitur et fringilla risus, eu aliquet enim. Aenean congue enim mauris, eget facilisis odio molestie non. Curabitur id varius mauris. Phasellus nec lacinia nibh. In dui sem, luctus in nibh a, rutrum consectetur sapien. '),
                  leading: GestureDetector(
                    onTap: () => Get.toNamed('/account', arguments: {
                      "uid": null,
                    }),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://widgetwhats.com/app/uploads/2019/11/free-profile-photo-whatsapp-4.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
