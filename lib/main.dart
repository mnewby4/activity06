import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
//provider like helper class
//statemanagement handled thru the package -> efficient/seamless UI updates
//use provider class -> handle SM

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360; //const=consistency among classes
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;
  String msg = "You're a child!";
  MaterialColor myColor = Colors.lightBlue;

  void increment() {
    value += 1;
    setMilestone();
    notifyListeners();
  }
  void decrement() {
    value -= 1;
    setMilestone();
    notifyListeners();
  }

  void setMilestone() {
    if (value >= 51) {
      msg = "Golden years!";
      myColor = Colors.grey;
    } else if (value >= 31) {
      msg = "You're an adult now!";
      myColor = Colors.orange;
    } else if (value >= 20) {
      msg = "You're a young adult!";
      myColor = Colors.yellow;
    } else if (value >= 13) {
      msg = "Teenager time!";
      myColor = Colors.lightGreen;
    } else {
      msg = "You're a child!";
      myColor = Colors.lightBlue;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //var counterInstance = Counter();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consumer looks for an ancestor Provider widget
            // and retrieves its model (Counter, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Consumer<Counter>(
              builder: (context, counter, child) => 
                Container(
                  color: counter.myColor,
                  child: Column(
                    children: <Widget>[
                      Text(
                      'I am ${counter.value} years old\n ${counter.msg}',
                      style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      ElevatedButton(
                        onPressed: counter.increment, 
                        child: Text('Increment Age')
                      ),
                      ElevatedButton(
                        onPressed: counter.decrement, 
                        child: Text('Decrement Age')
                      ),
                  ]),
                ),
            ),
            /*ElevatedButton(
              child: 
                Text('Increase Age'),
              onPressed: () => counterInstance.increment(),
            ),*/
          ],
        ),
      ),
    );
  }
}
