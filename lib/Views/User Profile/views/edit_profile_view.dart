import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/Views/User%20Profile/controller/user_profile_controller.dart';
import 'package:flutter_twitter_clone/core/utils.dart';

import '../../../theme/pallete.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const EditProfileView(),
    fullscreenDialog: true,
  );
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  File? _bannerFile;
  File? _profileFile;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserdetailsProvider).value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _selectBanner() async {
    final image = await pickImage();
    if (image != null) setState(() => _bannerFile = image);
  }

  void _selectProfile() async {
    final image = await pickImage();
    if (image != null) setState(() => _profileFile = image);
  }

  void _save() {
    final user = ref.read(currentUserdetailsProvider).value;
    if (user == null) return;

    ref.read(userProfileControllerProvider.notifier).updateUserProfile(
      userModel: user.copyWith(
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
      ),
      context: context,
      bannerFile: _bannerFile,
      profileFile: _profileFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserdetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Edit profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ElevatedButton(
              onPressed: isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.whiteColor,
                foregroundColor: Pallete.backgroundColor,
                disabledBackgroundColor: Pallete.whiteColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image area
            SizedBox(
              height: 180,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner
                  GestureDetector(
                    onTap: _selectBanner,
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      color: Pallete.backgroundColor,
                      child: _bannerFile != null
                          ? Image.file(_bannerFile!, fit: BoxFit.cover)
                          : user.bannerPic.isNotEmpty
                          ? Image.network(
                        user.bannerPic,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildBannerPlaceholder(),
                      )
                          : _buildBannerPlaceholder(),
                    ),
                  ),

                  // Camera icon overlay on banner
                  Positioned(
                    top: 50,
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    child: GestureDetector(
                      onTap: _selectBanner,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Avatar
                  Positioned(
                    left: 16,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _selectProfile,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Pallete.backgroundColor,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _profileFile != null
                                ? Image.file(_profileFile!,
                                fit: BoxFit.cover)
                                : user.profilePic.isNotEmpty
                                ? Image.network(
                              user.profilePic,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person,
                                  color: Pallete.greyColor,
                                  size: 40),
                            )
                                : const Icon(Icons.person,
                                color: Pallete.greyColor,
                                size: 40),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Your name',
                    maxLength: 50,
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel('Bio'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _bioController,
                    hint: 'Tell the world about yourself',
                    maxLines: 4,
                    maxLength: 160,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerPlaceholder() {
    return Container(
      color: Pallete.backgroundColor,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Pallete.greyColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Pallete.greyColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Pallete.searchBarColor, width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(color: Pallete.whiteColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Pallete.greyColor),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          counterStyle: const TextStyle(color: Pallete.greyColor, fontSize: 12),
        ),
      ),
    );
  }
}
