import 'package:flutter/cupertino.dart';

void main() {
  runApp(const LeoWorkstationApp());
}

class LeoWorkstationApp extends StatelessWidget {
  const LeoWorkstationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Leo Workstation',
      home: WorkstationShell(),
    );
  }
}

class WorkstationShell extends StatelessWidget {
  const WorkstationShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Leo Workstation'),
      ),
      child: Center(
        child: Text('Workstation shell'),
      ),
    );
  }
}
