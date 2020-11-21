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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String a = "";
  List<Words> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFromAsset();
    parseJson();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, //每行三列等
                        childAspectRatio: 2.0
                    ),
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      //如果显示到最后一个并且Icon总数小于200时继续获取数据
                      return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))),

                          child: Container(
                            alignment: Alignment.center,
                            color: _getColor(_list[index].highlight),
                            child: Text(
                                _list[index].name,
                                textAlign: TextAlign.center
                            ),
                          )
                      );
                    })),
            Padding(
                padding: EdgeInsets.all(29.0),
                child: Column(children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: '第一項'),
                    controller: _editingFirstController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第二項'),
                    controller: _editingSecondController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第三項'),
                    controller: _editingThirdController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第四項'),
                    controller: _editingFourthController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: '第五項'),
                    controller: _editingFiveController,
                  ),
                ])),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("開始搜尋"),
              onPressed: () =>
              {
                // print(_editingFirstController.text)
                print(a)
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
        //竖向排布的布局
        children: <Widget>[
          Text(_list[index].name),
        ],
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    );
  }

  Color _getColor(bool match) {
    print(match);
    if (match)
      return Colors.red;
    else
      return Colors.white;
  }
}
