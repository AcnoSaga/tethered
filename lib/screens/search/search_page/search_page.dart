import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import '../../components/gap.dart';
import '../../write/write_page/components/draft_item.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: TetheredColors.primaryDark,
        title: Wrap(
          children: [
            ChoiceChip(
              label: Text('Works'),
              selected: false,
              onSelected: (bool selected) {},
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Users'),
              selected: true,
              onSelected: (bool selected) {},
              selectedColor: TetheredColors.textFieldBackground,
            ),
            Gap(width: 2),
            ChoiceChip(
              label: Text('Tags'),
              selected: false,
              onSelected: (bool selected) {},
              selectedColor: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sy * 3),
          child: SearchBar(
            mainAxisSpacing: sx * 2,
            textStyle: TetheredTextStyles.descriptionText,
            icon: Icon(
              Icons.search,
              color: TetheredTextStyles.descriptionText.color,
            ),
            cancellationWidget: Text(
              'Cancel',
              style: TetheredTextStyles.descriptionText,
            ),
            loader: CircularProgressIndicator(),
            shrinkWrap: true,
            onItemFound: (item, index) {
              return DraftItem(
                published: true,
              );
            },
            onSearch: (String text) {
              return Future.value(List.filled(10, 1));
            },
          ),
        ),
      ),
    );
  }
}
