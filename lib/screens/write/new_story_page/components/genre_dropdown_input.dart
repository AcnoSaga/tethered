import 'package:flutter/material.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/enums/resource_types.dart';
import '../../../../utils/text_styles.dart';

class ResourceDropdownInput extends StatelessWidget {
  final ResourceTypes resourceType;
  final List<String> categoryList;
  final void Function(String) onSelect;

  const ResourceDropdownInput(
      {Key key, this.resourceType, this.categoryList, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: TetheredColors.textFieldBackground,
      hint: Text(
        () {
          if (resourceType == ResourceTypes.genre) {
            return 'Choose a genre';
          } else if (resourceType == ResourceTypes.hashtag) {
            return 'Choose a hashtag';
          }
          throw UnimplementedError();
        }(),
        style: TetheredTextStyles.textField,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: TetheredColors.textFieldBackground,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(3.0),
        ),
        hintStyle: TetheredTextStyles.textField,
      ),
      items: categoryList
          .map((str) => DropdownMenuItem(
                onTap: () {
                  if (onSelect != null) onSelect(str);
                },
                child: Text(
                  str,
                  style: TetheredTextStyles.textField,
                ),
                value: str,
              ))
          .toList(),
      onChanged: (item) {},
    );
  }
}
