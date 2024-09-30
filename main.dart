import 'package:flutter/material.dart';

import 'solana_service.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> info = [];

  @override
  void initState() {
    super.initState();
    SolanaService.fullRun(info);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solana Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Solana Integration'),
        ),
        body: StreamBuilder(
            stream: Stream.periodic(const Duration(milliseconds: 300)),
            builder: (context, snapshot) {
              return Center(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: List.generate(
                    info.length,
                    (index) => Text(
                      info.elementAt(index),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
