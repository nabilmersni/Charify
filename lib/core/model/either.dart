abstract class Either<L, R> {
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left({required this.value});

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return leftFn(value);
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right({required this.value});

  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    return rightFn(value);
  }
}
