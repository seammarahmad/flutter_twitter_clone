import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_twitter_clone/Views/tweet/view/create_tweet_view.dart';
import 'package:flutter_twitter_clone/constants/constants.dart';
import 'package:flutter_twitter_clone/theme/pallete.dart';


class HomePage extends StatefulWidget {
  static String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _page=0;

  onPageChange(int index){
    setState(() {
      _page=index;
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: UIConstants.appBar(),

      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){
        Navigator.pushNamed(context, CreateTweetView.id);
      },),

      bottomNavigationBar: CupertinoTabBar(
          onTap: onPageChange,
          currentIndex: _page,
          backgroundColor: Pallete.backgroundColor,
          items: [
        BottomNavigationBarItem(icon: SvgPicture.asset(_page==0?'assets/svgs/home_filled.svg':'assets/svgs/home_outlined.svg',color: Pallete.whiteColor,)),
        BottomNavigationBarItem(icon: SvgPicture.asset('assets/svgs/search.svg',color: Pallete.whiteColor)),
        BottomNavigationBarItem(icon: SvgPicture.asset(_page==2?'assets/svgs/notif_filled.svg':'assets/svgs/notif_outlined.svg',color: Pallete.whiteColor)),
      ]),

    );
  }
}
