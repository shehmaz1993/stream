import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> ls =[];
  TextEditingController controller =TextEditingController();
  StreamSocket socket = StreamSocket();
  @override
  Widget build(BuildContext context) {

    Stream<DateTime> generateNumber()async* {
      while(true){
        await Future.delayed(const Duration(seconds: 1));
        yield DateTime.now();
      }
    }

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text("Stream"),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
                stream: socket.getResponse,
                builder: (context,AsyncSnapshot<List<String>> snapshot){
                  return Text(snapshot.data.toString());
                }
            ),

          ],
        ),
      ),
      floatingActionButton:Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Enter message'
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              ls.add(controller.text.toString());
              socket.addResponse(ls);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class StreamSocket{

  final _stream = StreamController<List<String>>.broadcast();
  void Function(List<String>) get  addResponse => _stream.sink.add;
  Stream<List<String>> get getResponse => _stream.stream.asBroadcastStream();


}
