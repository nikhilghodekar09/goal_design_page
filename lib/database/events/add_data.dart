import 'package:goals_app/database/model/data.dart';

import 'data_event.dart';


class AddData extends DataEvent {
  Data newData;

  AddData(Data data) {
    newData = data;
  }
}
