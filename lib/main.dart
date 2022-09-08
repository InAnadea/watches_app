import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'WatchOS Golf Demo',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const channel = MethodChannel('myWatchChannel');

  int _score = 0;
  int _hole = 1;

  @override
  void initState() {
    super.initState();
    _initFlutterChannel();
  }

  void _initFlutterChannel() {
    channel.setMethodCallHandler((call) async {
      // Receive data from Native
      switch (call.method) {
        case "sendScoreToFlutter":
          setState(() {
            _score = call.arguments["data"]["score"];
          });
          break;

        case 'sendHoleToFlutter':
          setState(() {
            _hole = call.arguments["data"]["hole"];
          });
          break;

        default:
          break;
      }
    });
  }

  Future<void> _setScore(int score) async {
    setState(() {
      _score = score;
    });
    await channel.invokeMethod(
      "flutterToWatch",
      {
        "method": "sendScoreToNative",
        "data": _score,
      },
    );
  }

  Future<void> _setHole(int hole) async {
    setState(() {
      _hole = hole;
    });
    await channel.invokeMethod(
      "flutterToWatch",
      {
        "method": "sendHoleToNative",
        "data": _hole,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Golf WatchOS demo'),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Score'),
                Text(
                  '$_score',
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => _setScore(_score + 1),
                      child: const Icon(CupertinoIcons.arrow_up),
                    ),
                    CupertinoButton(
                      onPressed:
                          _score > 0 ? () => _setScore(_score - 1) : null,
                      child: const Icon(CupertinoIcons.arrow_down),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Hole'),
                Text(
                  '$_hole',
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                Row(
                  children: [
                    CupertinoButton(
                      onPressed: () => _setHole(_hole + 1),
                      child: const Icon(CupertinoIcons.arrow_up),
                    ),
                    CupertinoButton(
                      onPressed: _hole > 1 ? () => _setHole(_hole - 1) : null,
                      child: const Icon(CupertinoIcons.arrow_down),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
