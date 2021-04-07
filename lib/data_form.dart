import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'database/bloc/data_bloc.dart';
import 'database/db/database_provider.dart';
import 'database/events/add_data.dart';
import 'database/events/update_data.dart';
import 'database/model/data.dart';

class DataForm extends StatefulWidget {
  final Data data;
  final int dataIndex;

  DataForm({this.data, this.dataIndex});

  @override
  State<StatefulWidget> createState() {
    return DataFormState();
  }
}

class DataFormState extends State<DataForm> {
  DateTime setDate = DateTime.now();
  String _name= "My Goals";

//  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      style: TextStyle(color: Colors.blue,),
      maxLength: 10,
      decoration: InputDecoration( hintText: "Add data" ),
      initialValue: _name,
      keyboardType: TextInputType.text,
/*      validator: (String value) {
        if (value.isEmpty) {
          return 'data is Required';
        }
        return null;
      },*/
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _name = widget.data.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Data")),
      body: Form(

        key: _formKey,
        autovalidate: true,
        child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
            children: <Widget>[

                  Center(child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Click Submit to add data",style: TextStyle(color: Colors.amber,fontSize: 20.0,fontWeight: FontWeight.bold),),
                  )),
                 Visibility(
                     visible: false,
                     child: Center(child: _buildName())),

                    widget.data == null
                        ? RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        Data data = Data(
                            name: _name,
                        );

                        DatabaseProvider.db.insert(data).then(
                              (storedData) =>
                              BlocProvider.of<DataBloc>(context).add(
                                AddData(storedData),
                              ),
                        );
                        Navigator.pop(context);
                      },

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.blue,width: 2)
                      ),
                      textColor:Colors.white,child: Text("Submit"),
                    ) : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            print("form");
                            return;
                          }
                          _formKey.currentState.save();
                          Data data = Data(
                              name: _name,
                          );

                          DatabaseProvider.db.update(widget.data).then(
                                (storedData) =>
                                BlocProvider.of<DataBloc>(context).add(
                                  UpdateData(widget.dataIndex, data),
                                ),
                          );

                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }
}