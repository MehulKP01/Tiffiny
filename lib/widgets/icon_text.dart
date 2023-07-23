import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiffiny/utils/dimensions.dart';
import 'package:tiffiny/widgets/small_text.dart';

class IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color Iconcolor;
  const IconAndText(
      {Key? key,
      required this.icon,
      required this.text,
      required this.Iconcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Iconcolor,
          size: Dimensions.iconsize,
        ),
        SizedBox(
          width: 5,
        ),
        SmallText(
          text: text,
        )
      ],
    );
  }
}
