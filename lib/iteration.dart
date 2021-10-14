void times(int n, Function(int i) callback) {
  for (var i = 0; i < n; i++) {
    callback(i);
  }
}

void downFrom(int n, Function(int i) callback) {
  for (var i = n; i > 0; i--) {
    callback(i);
  }
}
