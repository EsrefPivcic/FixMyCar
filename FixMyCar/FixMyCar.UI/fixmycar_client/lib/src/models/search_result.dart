class SearchResult<T> {
  int count = 0;
  List<T> result = [];

  SearchResult({
    required this.count,
    required this.result,
  });
}
