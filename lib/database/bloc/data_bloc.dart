import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goals_app/database/events/add_data.dart';
import 'package:goals_app/database/events/data_event.dart';
import 'package:goals_app/database/events/delete_data.dart';
import 'package:goals_app/database/events/set_datas.dart';
import 'package:goals_app/database/events/update_data.dart';
import 'package:goals_app/database/model/data.dart';

class DataBloc extends Bloc<DataEvent, List<Data>> {
  @override
  List<Data> get initialState => List<Data>();

  @override
  Stream<List<Data>> mapEventToState(DataEvent event) async* {
    if (event is SetDatas) {
      yield event.dataList;
    } else if (event is AddData) {
      List<Data> newState = List.from(state);
      if (event.newData != null) {
        newState.add(event.newData);
      }
      yield newState;
    } else if (event is DeleteData) {
      List<Data> newState = List.from(state);
      newState.removeAt(event.dataIndex);
      yield newState;
    } else if (event is UpdateData) {
      List<Data> newState = List.from(state);
      newState[event.dataIndex] = event.newData;
      yield newState;
    }
  }
}
