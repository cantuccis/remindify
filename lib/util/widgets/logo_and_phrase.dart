import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remindify/util/assets.dart';

class LogoAndSlogan extends StatelessWidget {
  const LogoAndSlogan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 45, left: 45, right: 45, bottom: 15),
            child: SvgPicture.asset(AssetUri.appIconSvg, height: 80),
          ),
        ),
        Center(
          child: Text(
            "Never forget your tasks ever again!",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w200),
          ),
        ),
      ],
    );
  }
}
