import 'package:goals_app/database/model/data.dart';

import 'data_event.dart';

class SetDatas extends DataEvent {
  List<Data> dataList;

  SetDatas(List<Data> datas) {
    dataList = datas;
  }
}
