
import 'package:goals_app/database/model/data.dart';

import 'data_event.dart';

class UpdateData extends DataEvent {
  Data newData;
  int dataIndex;

  UpdateData(int index, Data data) {
    newData = data;
    dataIndex = index;
  }
}
