abstract class StorageRepositoryAbstract {
  Future<dynamic> get();
  Future<void> save({dynamic value});
}
