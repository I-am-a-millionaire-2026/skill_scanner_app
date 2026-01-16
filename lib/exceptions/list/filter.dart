extension FilterListStream<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) test) {
    return map((list) => list.where(test).toList());
  }
}
