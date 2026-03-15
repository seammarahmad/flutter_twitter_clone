import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../model/usermodel.dart';
import '../../../theme/pallete.dart';
import '../../User Profile/views/user_profile_view.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;

  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        UserProfileView.route(userModel),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Pallete.backgroundColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: userModel.profilePic.isNotEmpty
            ? Image.network(
                userModel.profilePic,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: Pallete.greyColor),
              )
            : const Icon(Icons.person, color: Pallete.greyColor),
      ),
      title: Row(
        children: [
          Text(
            userModel.name,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (userModel.isTwitterBlue)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: SvgPicture.asset('assets/svgs/verified.svg', height: 16),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(color: Pallete.greyColor, fontSize: 13),
          ),
          if (userModel.bio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                userModel.bio,
                style: const TextStyle(color: Pallete.greyColor, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Pallete.greyColor,
        size: 14,
      ),
    );
  }
}
