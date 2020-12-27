class RequiredParts {
  List _parts = [];

  List toJson() {
    return _parts;
  }

  List get parts => _parts;

  void addParts(value) {
    _parts.add(value);
  }

  void removeParts(index) {
    _parts.removeAt(index);
  }

  void editParts(index, key, value) {
    _parts[index][key] = value;
  }
}