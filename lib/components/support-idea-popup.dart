import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/constants.dart';

class SupportIdeaPopupCard extends StatelessWidget {
  final TextEditingController controller;

  const SupportIdeaPopupCard({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'other_idea',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ).tr(),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                  ),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'write_some_thing'.tr(),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    cursorColor: kPrimaryColor,
                    maxLines: 6,
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                  ),
                  ButtonWidget(
                    text: 'OK',
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
