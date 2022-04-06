import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamma/Shared/component.dart';
import 'package:lamma/cubit/SocialCubit.dart';
import 'package:lamma/cubit/states.dart';
import 'package:lamma/translations/local_keys.g.dart';


class ResetPasswordScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var resetKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state) {},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              child: Column(
                children: [
                  Text(LocaleKeys.changePassword.tr(),
                    style: TextStyle(color: SocialCubit.get(context).textColor,fontSize: 50,fontWeight: FontWeight.bold),),
                  Text(LocaleKeys.EnterAssociatedEmail.tr(),
                  style: TextStyle(color: SocialCubit.get(context).textColor,fontSize: 20),),
                  SizedBox(height: 40,),
                  defaultFormField(
                      context: context,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: LocaleKeys.EmailAddress.tr(),
                      prefix: Icons.email,
                      validate: (value)
                      {
                        if(value!.isEmpty)
                          return LocaleKeys.ThisFieldMustBeFilled.tr();
                      }
                  ),
                  SizedBox(height: 20,),
                  state is ResetPasswordLoadingState ?
                  Center(child: CircularProgressIndicator())
                      :defaultButton(context: context,
                    text: LocaleKeys.changePassword.tr(),
                    onTap: () {
                      if (resetKey.currentState!.validate()) {
                        SocialCubit.get(context).resetPassword(
                          email: emailController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
