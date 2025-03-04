extension NullFilters<T extends Object> on Stream<T?> {
  Stream<T?> whereNull() => where((e) => e == null);
}
