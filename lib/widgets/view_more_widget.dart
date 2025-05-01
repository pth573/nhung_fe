import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ViewMoreWidget extends StatelessWidget {
  final Function()? onTap;
  const ViewMoreWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            const Text('Xem chi tiết', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            )),
            SvgPicture.asset('assets/icons/icon_double_down.svg'),
          ],
        ),
      ),
    );
  }
}
