import 'package:flutter/material.dart';
import 'package:projectmobile/pages/pin_login/widgets/pin_button.dart';
import 'package:projectmobile/pages/home/home_page.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({Key? key});

  static const _keypad = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [-2, 0, -1] // -2 = Clear, -1 = Back
  ];

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  static const inputLength = 6;
  static const password = '000000';
  String _input = '';

  @override
  Widget build(BuildContext context) {
    print('Your input is $_input');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(
                  'assets/images/rick.png',
                  width: 350, // กำหนดความกว้างของรูปภาพ
                  height: 150, // กำหนดความสูงของรูปภาพ
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'ใส่รหัส PIN เพื่อดำเนินการต่อ',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _input.length; i++)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.radio_button_checked,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              for (var i = 0; i < inputLength - _input.length; i++)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.radio_button_unchecked,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
          _buildKeypad(),
        ],
      ),
    );
  }

  Column _buildKeypad() {
    return Column(
      children: [
        for (var row in PinLoginPage._keypad) _buildRow(row),
      ],
    );
  }

  void _handleClickButton(int num) {
    setState(() {
      if (_input.length >= inputLength) {
        return;
      }

      if (num == -1) {
        _input = _input.substring(0, _input.length - 1);
      } else if (num == -2) {
        _input = '';
      } else {
        _input += num.toString();
      }

      if (_input.length == password.length) {
        if (_input == password) {
          print('Password is correct!!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          _showError();
          _input = '';
        }
      }
    });
  }

  Widget _buildRow(List<int> numList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var num in numList)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: PinButton(
              num: num,
              onClick: () {
                _handleClickButton(num);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _showError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sorry!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Password is incorrect.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}