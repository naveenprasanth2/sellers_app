import 'package:flutter/material.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String? message;

  const LoadingDialogWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 14),
            child: const SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
              ),
            ),
          ),
          SizedBoxHelper.sizeBox30,
          Text(
            "$message, please wait ...",
          ),
        ],
      ),
    );
  }
}
