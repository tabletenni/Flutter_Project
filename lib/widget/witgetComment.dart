import 'package:flutter/material.dart';

class widgetComment extends StatefulWidget {

  const widgetComment({
    super.key,
  });

  @override
  State<widgetComment> createState() => _widgetCommentState();
}

class _widgetCommentState extends State<widgetComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                children: [
                  Text('test')
                ],
              );
            },
          );
        },
        child: Text('test'),
      ),
    );
  }
}
