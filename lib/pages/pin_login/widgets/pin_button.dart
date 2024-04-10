import 'package:flutter/material.dart';

class PinButton extends StatelessWidget {
  const PinButton({Key? key, required this.num, required this.onClick}) : super(key: key);

  final int num;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String? label;
    // num = 0-9
    List<String> labelList = [
      'ZERO',
      'ONE',
      'TWO',
      'THREE',
      'FOUR',
      'FIVE',
      'SIX',
      'SEVEN',
      'EIGHT',
      'NINE',
    ];

    if (num >= 0 && num <= 9) {
      label = labelList[num];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: 60.0, // 160 = 1 inch
          height: 60.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (num >= 0 && num <= 9)
                  Text(
                    num.toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // เปลี่ยนสีตัวเลขเป็นสีฟ้า
                    ),
                  ),
                if (num >= 0 && num <= 9)
                  Text(
                    label ?? '',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.blueAccent, // เปลี่ยนสีตัวเลขเป็นสีฟ้า
                    ),
                  ),
                if (num == -2)
                  Icon(
                    Icons.close,
                    color: Colors.blueAccent, // เปลี่ยนสีไอคอนเป็นสีฟ้า
                  ),
                if (num == -1)
                  Icon(
                    Icons.backspace,
                    color: Colors.blueAccent, // เปลี่ยนสีไอคอนเป็นสีฟ้า
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
