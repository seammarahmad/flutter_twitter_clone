import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_clone/Views/LoginViews/controller/auth_controller.dart';
import 'package:flutter_twitter_clone/Views/tweet/view/create_tweet_view.dart';
import 'package:flutter_twitter_clone/constants/constants.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';


class HomePage extends ConsumerStatefulWidget {
  static String id = 'home_page';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  int _page=0;

  onPageChange(int index){
    setState(() {
      _page=index;
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/svgs/twitter_logo.svg',
          color: Pallete.blueColor,
          height: 30,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerprovider.notifier).logout(context);
            },
            icon: const Icon(Icons.logout, color: Pallete.whiteColor),
          ),
        ],
      ),

      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),

      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add), onPressed: (){
        Navigator.pushNamed(context, CreateTweetView.id);
      },),

      bottomNavigationBar: CupertinoTabBar(
          onTap: onPageChange,
          currentIndex: _page,
          backgroundColor: Pallete.backgroundColor,
          items: [
        BottomNavigationBarItem(icon: SvgPicture.asset(_page==0?'assets/svgs/home_filled.svg':'assets/svgs/home_outlined.svg',colorFilter: const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),)),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/svgs/search.svg',colorFilter: const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn))),
        BottomNavigationBarItem(icon: SvgPicture.asset(_page==2?'assets/svgs/notif_filled.svg':'assets/svgs/notif_outlined.svg',colorFilter: const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn))),
      ]),

    );
  }
}
