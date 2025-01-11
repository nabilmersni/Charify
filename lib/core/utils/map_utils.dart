extension MapUtils on Map {
  withoutNulls() {
    removeWhere((key, value) => key == null || value == null);
    return this;
  }
}
