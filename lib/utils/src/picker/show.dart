import 'base_multi_data_picker.dart';

String kBaseMultiDataPickerCancelTitle = "Cancel";
String kBaseMultiDataPickerConfirmTitle = "Confirm";

Future<void> showBaseMultiDataPicker(
    {required List<List<String>> list,
    List<int>? selectedIndexList,
    required ConfirmButtonClick confirm}) async {
  GeneralMultiDataPicker(
    sync: false,
    delegate: _CustomDelegate(list: list, selectedIndexList: selectedIndexList),
    confirmClick: confirm,
  ).show();
}

class _CustomDelegate implements GeneralMultiDataPickerDelegate {
  final List<List<String>> list;
  List<int>? selectedIndexList;

  _CustomDelegate({required this.list, this.selectedIndexList});

  @override
  int numberOfComponent() {
    return list.length;
  }

  @override
  int numberOfRowsInComponent(int component) {
    return list[component].length;
  }

  @override
  String titleForRowInComponent(int component, int index) {
    return list[component][index];
  }

  @override
  double? rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    selectedIndexList ??= List.generate(list.length, (index) => 0);
    selectedIndexList?[component] = row;
  }

  @override
  int initSelectedRowForComponent(int component) {
    selectedIndexList ??= List.generate(list.length, (index) => 0);
    return selectedIndexList?[component] ?? 0;
  }
}
