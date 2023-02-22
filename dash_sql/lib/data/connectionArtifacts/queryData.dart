

class QueryResult {
  List<String>?        fields;
  List<List<String?>>? data;
  String?              errorMessage;
  QueryResult({this.errorMessage}) {
    if(errorMessage == null) {
      data   = <List<String?>>[];
    }
  }


  void addRecord(Map<String, dynamic> data) {
    if(fields == null) { 
      fields = <String>[];
      data.forEach((key, value) { fields!.add(key); });
     }
     List<String?> dataRows = <String?>[];
     data.forEach((key, value) { dataRows.add((value == null ? null : value.toString())); });
     this.data!.add(dataRows);
  }

}