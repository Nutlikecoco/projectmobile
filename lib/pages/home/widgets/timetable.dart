import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmobile/models/Rickandmorty.dart';

class _TimeTableState extends State<TimeTable> {
  List<Rickandmorty>? _rickMorty;
  bool _isDarkMode = false;
  Set<String> _favoriteCharacters =
      Set(); // เพิ่ม Set เพื่อเก็บรายการที่ถูกกดใจไว้
  bool _isThaiLanguage = true; // เพิ่มตัวแปรเพื่อเก็บสถานะการใช้งานภาษาไทย

  @override
  void initState() {
    super.initState();
    _fetchRickMorty();
  }

  Future<void> _fetchRickMorty() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response =
        await dio.get('https://api.sampleapis.com/rickandmorty/characters');
    print('Status code: ${response.statusCode}');
    response.headers.forEach((name, values) {
      print('$name: $values');
    });
    print(response.data.toString());

    setState(() {
      List list = jsonDecode(response.data.toString());
      _rickMorty = list.map((item) => Rickandmorty.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_isThaiLanguage ? 'ริคแอนด์มอร์ตี้' : 'Rick And Morty'),
          actions: [
            Row(
              children: [
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          favoriteCharacters: _favoriteCharacters,
                          isThaiLanguage: _isThaiLanguage,
                          toggleLanguage: _toggleLanguage,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        // Refresh state when returning from settings page
                      });
                    });
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _rickMorty == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _rickMorty!.length,
                      itemBuilder: (context, index) {
                        var randM = _rickMorty![index];
                        bool isFavorite = _favoriteCharacters.contains(
                            randM.name); // เช็คว่ารายการนี้ถูกกดใจไว้หรือไม่
                        return ListTile(
                          title: Text(randM.name ?? ''),
                          subtitle: Text(randM.type ?? ''),
                          trailing: randM.image == ''
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      randM.image ?? '',
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: Colors.red);
                                      },
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between image and heart icon
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isFavorite) {
                                            _favoriteCharacters
                                                .remove(randM.name);
                                          } else {
                                            _favoriteCharacters
                                                .add(randM.name!);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                          onTap: () {
                            _showCharacterDetails(randM, isFavorite);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCharacterDetails(Rickandmorty character, bool isFavorite) {
    IconData genderIcon =
        character.gender == 'Female' ? Icons.female : Icons.male;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(character.name ?? ''),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (character.image != null && character.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.network(
                      character.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.badge, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(_isThaiLanguage
                                  ? 'ชื่อ: ${character.name ?? ''}'
                                  : 'Name: ${character.name ?? ''}'),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                      favoriteCharacters: _favoriteCharacters,
                                      isThaiLanguage: _isThaiLanguage,
                                      toggleLanguage: _toggleLanguage,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    // Refresh state when returning from settings page
                                  });
                                });
                              },
                              icon: Icon(Icons.settings),
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.man_4, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(_isThaiLanguage
                                  ? 'ชนิด: ${character.type ?? ''}'
                                  : 'Type: ${character.type ?? ''}'),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                      favoriteCharacters: _favoriteCharacters,
                                      isThaiLanguage: _isThaiLanguage,
                                      toggleLanguage: _toggleLanguage,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    // Refresh state when returning from settings page
                                  });
                                });
                              },
                              icon: Icon(Icons.settings),
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(genderIcon, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(_isThaiLanguage
                                  ? 'เพศ: ${character.gender ?? ''}'
                                  : 'Gender: ${character.gender ?? ''}'),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                      favoriteCharacters: _favoriteCharacters,
                                      isThaiLanguage: _isThaiLanguage,
                                      toggleLanguage: _toggleLanguage,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    // Refresh state when returning from settings page
                                  });
                                });
                              },
                              icon: Icon(Icons.settings),
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.public, color: Colors.grey.shade800),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(_isThaiLanguage
                                  ? 'ต้นกำเนิด: ${character.origin ?? ''}'
                                  : 'Origin: ${character.origin ?? ''}'),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                      favoriteCharacters: _favoriteCharacters,
                                      isThaiLanguage: _isThaiLanguage,
                                      toggleLanguage: _toggleLanguage,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    // Refresh state when returning from settings page
                                  });
                                });
                              },
                              icon: Icon(Icons.settings),
                              color: Color.fromRGBO(255, 255, 255, 0),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                10), // Add some spacing between details and favorite icon
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(_isThaiLanguage ? 'ปิด' : 'Close'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      favoriteCharacters: _favoriteCharacters,
                      isThaiLanguage: _isThaiLanguage,
                      toggleLanguage: _toggleLanguage,
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    // Refresh state when returning from settings page
                  });
                });
              },
              icon: Icon(
                Icons.settings,
                color: Color.fromRGBO(255, 255, 255, 255), // ทำให้ไอคอนโปร่งใส
                size: 0,
              ),
            )
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับสลับภาษา
  void _toggleLanguage() {
    setState(() {
      _isThaiLanguage = !_isThaiLanguage;
    });
  }
}

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class SettingsPage extends StatelessWidget {
  final Set<String> favoriteCharacters;
  final bool isThaiLanguage; // เพิ่มตัวแปรสำหรับเก็บสถานะการใช้งานภาษาไทย
  final VoidCallback toggleLanguage; // เพิ่ม Callback สำหรับสลับภาษา

  const SettingsPage(
      {Key? key,
      required this.favoriteCharacters,
      required this.isThaiLanguage, // รับค่าสถานะการใช้งานภาษาไทย
      required this.toggleLanguage}) // รับ Callback สำหรับสลับภาษา
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use widget.characters to access the passed data
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่า',
          style: TextStyle(
            color: Colors.white, // กำหนดสีของตัวหนังสือใน AppBar เป็นสีขาว
          ),
        ),
        backgroundColor:
            Colors.lightBlue, // กำหนดสีของพื้นหลังของ AppBar เป็นสีสว่างบลู
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'รายการโปรด',
              style: TextStyle(
                color: Colors.blue, // กำหนดสีของตัวหนังสือเป็นสีฟ้า
              ),
            ),
            onTap: () {
              _showFavoriteSettings(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(
              'เปลี่ยนภาษา',
              style: TextStyle(
                color: Colors.blue, // กำหนดสีของตัวหนังสือเป็นสีฟ้า
              ),
            ),
            onTap: () {
              _showLanguageSelectionDialog(
                  context); // เรียกฟังก์ชันแสดงหน้าต่างเลือกภาษา
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'ออกจากระบบ',
              style: TextStyle(
                color: Colors.blue, // กำหนดสีของตัวหนังสือเป็นสีฟ้า
              ),
            ),
            onTap: () {
              _confirmSignOut(context);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  void _showFavoriteSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายการโปรด'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: favoriteCharacters.map((character) {
                return ListTile(
                  title: Text(character),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันแสดงหน้าต่างเลือกภาษา
  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เปลี่ยนภาษา'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset('assets/images/thailand_flag.png',
                    width: 24, height: 24), // เพิ่มรูปภาพธงไทย
                title: Text('ไทย'),
                onTap: () {
                  // เรียกใช้งาน Callback สำหรับสลับภาษาและปิดหน้าต่างเลือกภาษา
                  toggleLanguage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/uk_flag.png',
                    width: 24, height: 24), // เพิ่มรูปภาพธงอังกฤษ
                title: Text('English'),
                onTap: () {
                  // เรียกใช้งาน Callback สำหรับสลับภาษาและปิดหน้าต่างเลือกภาษา
                  toggleLanguage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'), // ปุ่ม "ไม่"
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName('/pin_login_page'));
              },
              child: Text('Yes'), // ปุ่ม "ใช่"
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(TimeTable());
}
