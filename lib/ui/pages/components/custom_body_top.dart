import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CustomBodyTop extends StatelessWidget {
  final Size size;
  final String label;
  final Widget child;
  final double childSize;
  const CustomBodyTop({required this.size, required this.label, required this.child, required this.childSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.yellow,
                  AppColors.primaryColor,
                  AppColors.secondaryColor,
                ],
              ),
            )),
        SizedBox(
          height: size.height * 0.20,
          child: Stack(children: [
            Container(
              height: size.height * 0.20 - 27,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(label,
                        textAlign: TextAlign.center, style: AppTextStyle.poppins3.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: childSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: AppColors.primaryColor.withOpacity(0.23),
                      ),
                    ],
                  ),
                  child: child,
                ))
          ]),
        ),
      ],
    );
  }
}
