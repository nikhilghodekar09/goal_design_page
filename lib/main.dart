import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_list.dart';
import 'database/bloc/data_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyGoalAppState createState() => _MyGoalAppState();
}

class _MyGoalAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataBloc>(
      create: (context) => DataBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Goal App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DataList(),
      ),
    );
  }
}
