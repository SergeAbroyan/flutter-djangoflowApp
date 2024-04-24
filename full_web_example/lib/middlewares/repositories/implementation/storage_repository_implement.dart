import 'package:npua_project/middlewares/repositories/abstraction/storage_repository_abstract.dart';
import 'package:universal_html/html.dart';

class StorageRepositoryImp implements StorageRepositoryAbstract {
  final Storage _localStorage = window.localStorage;

  @override
  Future<void> save({value}) async {
    _localStorage['selected_id'] = value;
  }

  @override
  Future<dynamic> get() async {
    return _localStorage['selected_id'];
  }
}
