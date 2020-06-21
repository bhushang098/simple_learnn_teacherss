class CourseClass {
  String _bucket;
  Map<String, String> _files;
  int _price;
  String _Author;

  CourseClass(this._bucket, this._price, this._Author);

  Map<String, String> get files => _files;

  set files(Map<String, String> value) {
    _files = value;
  }

  String get bucket => _bucket;

  set bucket(String value) {
    _bucket = value;
  }
}
