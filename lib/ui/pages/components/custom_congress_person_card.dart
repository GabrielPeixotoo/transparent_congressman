import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../domain/entities/entities.dart';
import '../../theme/theme.dart';

class CustomCongressPersonCard extends StatelessWidget {
  final CongressPersonEntity congressPerson;
  const CustomCongressPersonCard({required this.congressPerson, super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: congressPerson.urlProfilePic,
          imageErrorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 34),
        ),
        title: Text(
          congressPerson.name,
          maxLines: 1,
          style: AppTextStyle.poppins2,
        ),
        subtitle: Text(
          congressPerson.partyAbbreviation,
          style: AppTextStyle.poppins2,
        ),
        trailing: SvgPicture.asset(
          congressPerson.stateSvg,
          height: 36,
          width: 36,
        ),
      );
}
