import 'package:example/components/timelines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resizable_widget/resizable_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Example'),
      ),
      body: ResizableWidget(isHorizontalSeparator: true, children: const [
        Row(
          children: [
            Expanded(child: Placeholder()),
            Expanded(child: Timelines()),
          ],
        ),
        Placeholder()
      ]),
    );
  }
}
