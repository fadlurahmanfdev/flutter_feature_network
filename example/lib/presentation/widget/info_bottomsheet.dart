import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoBottomsheet extends StatelessWidget {
  final String title;
  final String desc;

  const InfoBottomsheet({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 50),
          Text(desc),
          SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          )
        ],
      ),
    );
  }
}
