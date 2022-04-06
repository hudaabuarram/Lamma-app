import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamma/Layout/SocialLayout.dart';
import 'package:lamma/Shared/constants.dart';
import 'package:lamma/cubit/SocialCubit.dart';
import 'package:lamma/cubit/states.dart';
import 'package:lamma/Models/likesModel.dart';
import 'package:lamma/translations/local_keys.g.dart';

import 'friendsProfileScreen.dart';

class WhoLikedScreen extends StatelessWidget {
String ?postId;
WhoLikedScreen(this.postId);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      SocialCubit.get(context).getLikes(postId);
      return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state) {
            List<LikesModel> peopleReacted = SocialCubit.get(context).peopleReacted;
            return Scaffold(
              appBar: AppBar(
                title: Text(LocaleKeys.Peoplewhoreacted.tr()),
                titleSpacing: 0,
                elevation: 8,
              ),
              body: ListView.separated(
                  itemBuilder: (context,index) => userLikeItem(context, peopleReacted[index]),
                  separatorBuilder:(context,index) => SizedBox(height: 0,),
                  itemCount: peopleReacted.length
              ),
            );
      },
      );
    });
  }
  Widget userLikeItem (context,LikesModel userModel) {
    return Builder(
      builder:(context) {
        return InkWell(
        onTap: (){
          if (SocialCubit.get(context).model!.uID == userModel.uId)
            navigateTo(context, SocialLayout(3));
        else
            navigateTo(context, FriendsProfileScreen(userModel.uId));
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:NetworkImage('${userModel.profilePicture}'),
                radius: 20,
              ),
              SizedBox(width: 10,),
              Text('${userModel.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: SocialCubit.get(context).textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
              Spacer(),
              if (SocialCubit.get(context).model!.uID != userModel.uId)
                Container(
                width: 120,
                child: ElevatedButton(
                  style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
                  onPressed: (){
                    SocialCubit.get(context).addFriend(
                      friendName: userModel.name,
                      friendProfilePic: userModel.profilePicture,
                      friendsUid: userModel.uId
                    );
                    SocialCubit.get(context).getFriends(userModel.uId);
                  },
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_rounded,size: 15,),
                      SizedBox(width: 5,),
                      Text(LocaleKeys.addFriend.tr(),style: TextStyle(color: Colors.white,fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),);
      },
    );
  }

}
