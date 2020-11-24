import 'dart:convert';
import 'dart:math';

import 'package:find_dictionary/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '文字解碼'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _currentAnswer = "";
  List<Words> _list = [];
  List<Words> _originList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFromAsset();
    parseJson();
  }

  void _setCurrentAnswer(String currentAnswer) {
    setState(() {
      _currentAnswer = currentAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '最終答案：',
            ),
            Text(
              '$_currentAnswer',
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5),
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0))),
                          child: Container(
                            alignment: Alignment.center,
                            color: _getColor(
                                _list[index].highlight, _list[index].name),
                            child: Text(_list[index].name,
                                textAlign: TextAlign.center),
                          ));
                    })),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: '第一項'),
                    controller: _editingFirstController,
                    onChanged: (text) => {checkInMatch(text, 0)},
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第二項'),
                    controller: _editingSecondController,
                    onChanged: (text) => {checkInMatch(text, 1)},
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第三項'),
                    controller: _editingThirdController,
                    onChanged: (text) => {checkInMatch(text, 2)},
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第四項'),
                    controller: _editingFourthController,
                    onChanged: (text) => {checkInMatch(text, 3)},
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第五項'),
                    controller: _editingFiveController,
                    onChanged: (text) => {checkInMatch(text, 4)},
                  ),
                ])),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("開始搜尋"),
              onPressed: () => {checkInMatch(_editingFirstController.text, 1)},
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextEditingController _editingFirstController = TextEditingController();
  TextEditingController _editingSecondController = TextEditingController();
  TextEditingController _editingThirdController = TextEditingController();
  TextEditingController _editingFourthController = TextEditingController();
  TextEditingController _editingFiveController = TextEditingController();

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/dictionary.json");
  }

  Future parseJson() async {
    String jsonString = await _loadFromAsset();
    _list = List<Words>.from(
        json.decode(jsonString).map((data) => Words.fromJson(data))).toList();
    _originList.clear();
    _list.forEach((element) {
      _originList.add(new Words(element.name, element.highlight));
    });
  }

  void showSnackBar(BuildContext context) {
    final snackBar = new SnackBar(
      content: new Text('顯示訊息'),
      action: SnackBarAction(
        label: '復原',
        onPressed: () {
          print('復原...');
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _getItemView(context, index) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text(_list[index].name),
        ],
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    );
  }

  Color _getColor(bool match, String text) {
    if (match) {
      // debugPrint('設定為紅色: $text');
      return Colors.red;
    } else
      // print('設定為藍色 $text');
      return Colors.transparent;
  }

  //index = 1
  Future checkInMatch(String text, int index) async {
    _list.clear();
    _originList.forEach((element) {
      _list.add(new Words(element.name, element.highlight));
    });

    List<int> charArray = [];

    text.split('').forEach((textElement) {
      //textElement = a, c ,g , d
      _list.asMap().forEach((i, wordElement) {
        List<String> word = wordElement.name.split('');
        if (word[index] == textElement) {
          charArray.add(i);
        }
      });

      _list.asMap().forEach((listKey, value) {
        charArray.asMap().forEach((arrayKey, arrayValue) {
          if (listKey == arrayValue) {
            _list[listKey].highlight = true;
          }
        });
      });
    });

    setState(() {});
    var selectedItem = _list.where((element) => element.highlight == true);
    if (selectedItem.length == 1) {
      this._setCurrentAnswer(selectedItem.first.name);
    }
  }
}
