import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goals_app/platform_flat_button.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'bg_image.dart';
import 'data_form.dart';
import 'database/bloc/data_bloc.dart';
import 'database/db/database_provider.dart';
import 'database/events/delete_data.dart';
import 'database/events/set_datas.dart';
import 'database/model/data.dart';

enum Goal { personal, community }

class DataList extends StatefulWidget {
 const DataList({Key key}) : super(key: key);
  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  List<Data> images;
  String imagepath;

  String selectedDate;
  String selectedGoal;
  String radioItem = '';
  Color blueColor = Color(0xff548FB3);
  Color bluebackground = Color(0xff68AFB1);
  Color boxbackground = Color(0xffB48CB0);
  Color bluebox = Color(0xff648ACC);

  bool isRowVisible = false;
  bool isCircularprogressVisible = true;
  bool ismenubarVisible = true;
  bool isgoalVisible = true;

//  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  List<String> _dateType = <String>[
    'nothing to show',

  ];
  List<String> _goalType = <String>[
    'nothing to show',];

  List<String> options = <String>['One', 'Two', 'Free', 'Four'];
  String dropdownValue = 'One';

  Goal _goal = Goal.personal;

  DateTime setDate = DateTime.now();
  int _groupValue = -1;
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getDatas().then(
      (dataList) {
        BlocProvider.of<DataBloc>(context).add(SetDatas(dataList));
      },
    );
  }

  showDataDialog(BuildContext context, Data data, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to perform this operation?"),
        content: Text(data.name),
        actions: <Widget>[
          /*FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DataForm(data: data, dataIndex: index),
              ),
            ),
            child: Text("Update"),
          ),*/
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(data.id).then((_) {
              BlocProvider.of<DataBloc>(context).add(
                DeleteData(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            BgImage(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white.withOpacity(0.65),),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(width: 50,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Goals",
                          style: TextStyle(
                            fontSize: 20.0, color: Colors.white,
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.plusCircle,
                              color: Colors.white.withOpacity(0.65),),
                            onPressed: () {
                              setState(() {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DataForm()),
                                );
                                isgoalVisible = !isgoalVisible;
                              });
                            },
                          ),

                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.edit,
                              color: Colors.white.withOpacity(0.9),),
                            onPressed: () {
                              setState(() {});
                            },
                          ),

                          Visibility(
                            visible: isgoalVisible,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: IconButton(
                              icon: FaIcon(FontAwesomeIcons.ellipsisV,
                                color: Colors.white.withOpacity(0.7),),
                              onPressed: () {
                                setState(() {
                                  isRowVisible = !isRowVisible;
                                  isgoalVisible = !isgoalVisible;
                                  ismenubarVisible = !ismenubarVisible;
                                  isCircularprogressVisible =
                                  !isCircularprogressVisible;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5.0,
                  ),

                  Container(
                    padding: EdgeInsets.only(
                        top: 18.0, left: 18.0, right: 18.0),
                    child: BlocConsumer<DataBloc, List<Data>>(
                      builder: (context, dataList) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print("dataList: $dataList");
                            Data data = dataList[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                side: BorderSide(
                                  color: Colors.white70,
                                  width: 1.0,
                                ),
                              ),
                              color: Colors.blueAccent.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text("My Goals", style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                  ),

                                  Visibility(
                                    visible: isCircularprogressVisible,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              35),
                                          color: Colors.white.withOpacity(
                                              0.75), //BoxShadow
                                        ), //BoxDecoration
                                        child: CircularPercentIndicator(
                                          radius: 35.0,
                                          lineWidth: 3.0,
                                          animation: true,
                                          percent: 0.5,
                                          backgroundColor: Colors.black12,
                                          center: new Text(
                                            "50.0%",
                                            style:
                                            new TextStyle(fontSize: 10.0,
                                                color: Colors.lightBlue),
                                          ),
                                          //   footer: new Text(
                                          //   "Loading...",
                                          //   style:
                                          //   new TextStyle(fontWeight: FontWeight.bold, fontSize: 5.0),
                                          // ),
                                          circularStrokeCap: CircularStrokeCap
                                              .round,
                                          progressColor: Colors.blueAccent,
                                        )
                                    ),
                                  ),

                                  Visibility(
                                    visible: isRowVisible,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: bluebox,
                                              //        border: Border.all(width: 1, color: Colors.transparent)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2.0),
                                              child: IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color: Colors.white60,),
                                                onPressed: () {
                                                  showDataDialog(
                                                      context, data, index);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: bluebox,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2.0),
                                              child: IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons.edit,
                                                  color: Colors.white60,),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: bluebox,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  2.0),
                                              child: IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons.shareAlt,
                                                  color: Colors.white60,),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: bluebox,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: IconButton(
                                              icon: FaIcon(
                                                FontAwesomeIcons.bullseye,
                                                color: Colors.white60,),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: ismenubarVisible,
                                    child: IconButton(
                                      icon: FaIcon(FontAwesomeIcons.ellipsisV,
                                        color: Colors.white70,),
                                      onPressed: () {
                                        setState(() {
                                          isgoalVisible = true;
                                          ismenubarVisible = !ismenubarVisible;
                                          isRowVisible = !isRowVisible;
                                          isCircularprogressVisible =
                                          !isCircularprogressVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: dataList.length,
                        );
                      },
                      listener: (BuildContext context, dataList) {},
                    ),
                  ),

                  //      BgImage(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 18.0, top: 5.0),
                    child: Card(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: bluebackground,
                                borderRadius: BorderRadius.circular(3)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        hintText: 'Enter / Update Goals',
                                        isDense: true,
                                        // important line
                                        contentPadding: EdgeInsets.fromLTRB(
                                            40, 50, 40, 50),
                                        // control your hints text size
                                        hintStyle: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        fillColor: boxbackground,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(3.0),
                                                topRight: Radius.circular(3.0)),
                                            borderSide: BorderSide.none)),
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 3.0,
                                            left: 1.0,
                                            bottom: 8,
                                            top: 10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: blueColor,
                                              borderRadius: BorderRadius
                                                  .circular(3)),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dropdownValue,
                                            icon: Icon(Icons.keyboard_arrow_up,
                                              color: Colors.white70,),
                                            iconSize: 42,
                                            underline: SizedBox(),
                                            hint: Text(
                                              'Target Date',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0),
                                            ),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                            },
                                            /* items: <String>[
                                                'One',
                                              ].map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()*/
                                          ),
                                        ),
                                      ),


                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                right: 3.0,
                                                left: 1.0,
                                                bottom: 8,),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: blueColor,
                                                    borderRadius: BorderRadius
                                                        .circular(3)),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  mainAxisSize: MainAxisSize
                                                      .max,
                                                  children: [
                                                    Text(
                                                      "Date",
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white70,
                                                      ),
                                                    ),

                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .calendar_today_sharp,
                                                        color: Colors.white70,),
                                                      onPressed: () {
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                right: 3.0,
                                                left: 1.0,
                                                bottom: 8,),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: blueColor,
                                                    borderRadius: BorderRadius
                                                        .circular(3)),

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  mainAxisSize: MainAxisSize
                                                      .max,
                                                  children: [
                                                    Text(
                                                      "SGI Date",
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white70,
                                                      ),
                                                    ),

                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .calendar_today_sharp,
                                                        color: Colors.white70,),
                                                      onPressed: () {
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 3.0, left: 1.0, bottom: 8,),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: blueColor,
                                              borderRadius: BorderRadius
                                                  .circular(3)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Target Time",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white70,
                                                ),
                                              ),

                                              IconButton(
                                                icon: Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.white70,),
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),

                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 3.0, left: 1.0, bottom: 8,),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: blueColor,
                                              borderRadius: BorderRadius
                                                  .circular(3)),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dropdownValue,
                                            icon: Icon(Icons.keyboard_arrow_up,
                                              color: Colors.white70,),
                                            iconSize: 42,
                                            underline: SizedBox(),
                                            hint: Text(
                                              'Goal Type',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20.0),
                                            ),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20.0, right: 3.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: blueColor,
                                                  borderRadius: BorderRadius
                                                      .circular(3)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Radio(
                                                    value: Goal.personal,
                                                    groupValue: _goal,
                                                    onChanged: (Goal value) {
                                                      setState(() {
                                                        _goal = value;
                                                      });
                                                    },
                                                  ),
                                                  Text('Personal',
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 20.0)),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              width: 20.0,
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 1.0,),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1, vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: blueColor,
                                                    borderRadius: BorderRadius
                                                        .circular(3)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Radio(
                                                      value: Goal.community,
                                                      groupValue: _goal,
                                                      onChanged: (Goal value) {
                                                        setState(() {
                                                          _goal = value;
                                                        });
                                                      },
                                                    ),
                                                    Text('Community',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white70,
                                                            fontSize: 20.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 18.0),
                                        child: SizedBox(
                                          width: 300,
                                          height: 50,
                                          child: RaisedButton(
                                            color: Colors.white,
                                            onPressed: () {},
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(50.0),
                                                side: BorderSide(
                                                    color: Colors.white,
                                                    width: 2)
                                            ),
                                            textColor: Colors.grey,
                                            child: Text("Add", style: TextStyle(
                                                fontSize: 20.0),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //     IgnorePointer(ignoring:true,),
          ],
        ),
      ),
    );
  }



  fromDate(){
    PlatformFlatButton(
      handler: () => openDatePicker(),
      buttonChild: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Text(
            DateFormat("dd.MM").format(this.setDate),
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.event,
            size: 30,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
      color: Color.fromRGBO(7, 190, 200, 0.1),
    );
  }

  sgiDate(){
    PlatformFlatButton(
      handler: () => openDatePicker(),
      buttonChild: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Text(
            //   DateFormat("dd.MM").format(this.setDate),
            DateFormat("dd.MM").format(this.setDate),
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.event,
            size: 30,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
      color: Color.fromRGBO(7, 190, 200, 0.1),
    );
  }


  Future<void> openDatePicker() async {
    await showDatePicker(
        context: context,
        initialDate: setDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 100000)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setState(() => setDate = newDate);
      print(setDate.day);
      print(setDate.month);
      print(setDate.year);
    });
  }
}
