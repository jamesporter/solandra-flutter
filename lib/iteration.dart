times(int n, Function(int i) callback) {
  for (var i = 0; i < n; i++) {
    callback(i);
  }
}
