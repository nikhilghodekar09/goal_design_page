
import 'data_event.dart';

class DeleteData extends DataEvent {
  int dataIndex;

  DeleteData(int index) {
    dataIndex = index;
  }
}
