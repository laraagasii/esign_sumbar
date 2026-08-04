import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  var listRes = await http.get(
    Uri.parse(
      'https://espj.sumbarprov.go.id/sumbarapis/spj/nota-dinas/list/id/a4adb04d8392abc79d52ea247fabd8348b97a78a/group/6/status/MBB',
    ),
  );
  print('List: ${listRes.body}');
}
