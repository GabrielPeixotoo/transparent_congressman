import 'package:cached_network_image/cached_network_image.dart';
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
        minVerticalPadding: 8,
        leading: SizedBox(
          width: 36,
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: congressPerson.urlProfilePic,
              memCacheWidth: 108,
              memCacheHeight: 144,
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.memory(kTransparentImage),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey,
                child: const Icon(Icons.person, size: 24),
              ),
            ),
          ),
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
