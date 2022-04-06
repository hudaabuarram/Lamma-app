import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamma/Screens/HomeScreen.dart';
import 'package:lamma/Screens/SettingScreen.dart';
import 'package:lamma/Screens/notificationScreen.dart';
import 'package:lamma/Screens/profileScreen.dart';
import 'package:lamma/Screens/recentMessages.dart';
import 'package:lamma/Screens/searchScreen.dart';
import 'package:lamma/Screens/usersScreen.dart';
import 'package:lamma/Shared/constants.dart';
import 'package:lamma/Shared/iconBroken.dart';
import 'package:lamma/cubit/SocialCubit.dart';
import 'package:lamma/cubit/states.dart';


class SocialLayout extends StatefulWidget {
int initialIndex = 0;

SocialLayout(this.initialIndex);

@override
SocialLayoutState createState() => SocialLayoutState();
}

class SocialLayoutState extends State<SocialLayout>
    with SingleTickerProviderStateMixin {
  static late TabController tabController;
  static ScrollController scrollController = ScrollController();
  late int initialIndex;

  @override
  void initState() {
    initialIndex = widget.initialIndex;
    tabController = TabController(length: 6, vsync: this);
    tabController.index = initialIndex;
    tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: tabController.index == 0
                  ? AppBar(
                titleSpacing: 10,
                title:  Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/s.png'),
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10,),
                    Text('Lamma' ,style: TextStyle(color: Colors.teal),
                   ),

                  ],
                ),
                automaticallyImplyLeading: false,
                elevation: 8,
                actions: [
                  IconButton(
                      onPressed: () {
                        navigateTo(context, SearchScreen());
                      },
                      icon: Icon(Icons.search)),
                ],
                bottom: TabBar(
                  controller: tabController,
                  labelColor: Colors.teal,
                  tabs: tabBar(context),
                  onTap: (index) {
                    SocialCubit.get(context).changeBottomNav(index);
                  },
                  labelStyle: TextStyle(fontSize: 20),
                  indicatorColor: Colors.teal,
                  unselectedLabelColor: Colors.grey,
                ),
              )
                  : AppBar(
                automaticallyImplyLeading: false,
                elevation: 8,
                title: TabBar(
                  controller: tabController,
                  labelColor: Colors.teal,
                  tabs: tabBar(context),
                  onTap: (index) {
                    SocialCubit.get(context).changeBottomNav(index);
                  },
                  labelStyle: TextStyle(fontSize: 20),
                  indicatorColor: Colors.teal,
                  unselectedLabelColor: Colors.grey,
                ),
              ),
              body: TabBarView(
                  physics: RangeMaintainingScrollPhysics(),
                  controller: tabController,
                  children: SocialCubit.get(context).screens),
            );
          });
    });
  }

  List<Widget> tabBar(context) {
    return [
      Tab(
        icon: Icon(Icons.home_outlined),
      ),
      Tab(
        icon: SocialCubit.get(context).friendRequests.length != 0
            ? tabBarBadge(
            icon: Icons.group_outlined,
            count: SocialCubit.get(context).friendRequests.length)
            : Icon(Icons.group_outlined),
      ),
      Tab(
        icon: SocialCubit.get(context).unReadRecentMessagesCount != 0
            ? tabBarBadge(
            icon: IconBroken.Chat,
            count: SocialCubit.get(context).unReadRecentMessagesCount)
            : Icon(IconBroken.Chat),
      ),
      Tab(
        icon: Icon(IconBroken.Profile),
      ),
      Tab(
        icon: SocialCubit.get(context).unReadNotificationsCount != 0
            ? tabBarBadge(
            icon: IconBroken.Notification,
            count: SocialCubit.get(context).unReadNotificationsCount)
            : Icon(IconBroken.Notification),
      ),
      Tab(
        icon: Icon(Icons.menu),
      )
    ];
  }

  Widget tabBarBadge({required IconData icon, required int count}) {
    return Badge(
      badgeContent: Text('$count'),
      animationType: BadgeAnimationType.scale,
      child: Icon(icon),
    );
  }
}
