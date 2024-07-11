import 'dart:math';

class UsageQueue<T> implements List {
  @override
  var first;

  @override
  var last;

  @override
  late int length;

  @override
  List operator +(List other) {
    // TODO: implement +
    throw UnimplementedError();
  }

  @override
  operator [](int index) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(int index, value) {
    // TODO: implement []=
  }

  @override
  void add(value) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable iterable) {
    // TODO: implement addAll
  }

  @override
  bool any(bool Function(dynamic element) test) {
    // TODO: implement any
    throw UnimplementedError();
  }

  @override
  Map<int, dynamic> asMap() {
    // TODO: implement asMap
    throw UnimplementedError();
  }

  @override
  List<R> cast<R>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  bool contains(Object? element) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  elementAt(int index) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  bool every(bool Function(dynamic element) test) {
    // TODO: implement every
    throw UnimplementedError();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(dynamic element) toElements) {
    // TODO: implement expand
    throw UnimplementedError();
  }

  @override
  void fillRange(int start, int end, [fillValue]) {
    // TODO: implement fillRange
  }

  @override
  firstWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, dynamic element) combine) {
    // TODO: implement fold
    throw UnimplementedError();
  }

  @override
  Iterable followedBy(Iterable other) {
    // TODO: implement followedBy
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(dynamic element) action) {
    // TODO: implement forEach
  }

  @override
  Iterable getRange(int start, int end) {
    // TODO: implement getRange
    throw UnimplementedError();
  }

  @override
  int indexOf(element, [int start = 0]) {
    // TODO: implement indexOf
    throw UnimplementedError();
  }

  @override
  int indexWhere(bool Function(dynamic element) test, [int start = 0]) {
    // TODO: implement indexWhere
    throw UnimplementedError();
  }

  @override
  void insert(int index, element) {
    // TODO: implement insert
  }

  @override
  void insertAll(int index, Iterable iterable) {
    // TODO: implement insertAll
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  // TODO: implement iterator
  Iterator get iterator => throw UnimplementedError();

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    throw UnimplementedError();
  }

  @override
  int lastIndexOf(element, [int? start]) {
    // TODO: implement lastIndexOf
    throw UnimplementedError();
  }

  @override
  int lastIndexWhere(bool Function(dynamic element) test, [int? start]) {
    // TODO: implement lastIndexWhere
    throw UnimplementedError();
  }

  @override
  lastWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  Iterable<T> map<T>(T Function(dynamic e) toElement) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  reduce(Function(dynamic value, dynamic element) combine) {
    // TODO: implement reduce
    throw UnimplementedError();
  }

  @override
  bool remove(Object? value) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  removeAt(int index) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }

  @override
  removeLast() {
    // TODO: implement removeLast
    throw UnimplementedError();
  }

  @override
  void removeRange(int start, int end) {
    // TODO: implement removeRange
  }

  @override
  void removeWhere(bool Function(dynamic element) test) {
    // TODO: implement removeWhere
  }

  @override
  void replaceRange(int start, int end, Iterable replacements) {
    // TODO: implement replaceRange
  }

  @override
  void retainWhere(bool Function(dynamic element) test) {
    // TODO: implement retainWhere
  }

  @override
  // TODO: implement reversed
  Iterable get reversed => throw UnimplementedError();

  @override
  void setAll(int index, Iterable iterable) {
    // TODO: implement setAll
  }

  @override
  void setRange(int start, int end, Iterable iterable, [int skipCount = 0]) {
    // TODO: implement setRange
  }

  @override
  void shuffle([Random? random]) {
    // TODO: implement shuffle
  }

  @override
  // TODO: implement single
  get single => throw UnimplementedError();

  @override
  singleWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    // TODO: implement singleWhere
    throw UnimplementedError();
  }

  @override
  Iterable skip(int count) {
    // TODO: implement skip
    throw UnimplementedError();
  }

  @override
  Iterable skipWhile(bool Function(dynamic value) test) {
    // TODO: implement skipWhile
    throw UnimplementedError();
  }

  @override
  void sort([int Function(dynamic a, dynamic b)? compare]) {
    // TODO: implement sort
  }

  @override
  List sublist(int start, [int? end]) {
    // TODO: implement sublist
    throw UnimplementedError();
  }

  @override
  Iterable take(int count) {
    // TODO: implement take
    throw UnimplementedError();
  }

  @override
  Iterable takeWhile(bool Function(dynamic value) test) {
    // TODO: implement takeWhile
    throw UnimplementedError();
  }

  @override
  List toList({bool growable = true}) {
    // TODO: implement toList
    throw UnimplementedError();
  }

  @override
  Set toSet() {
    // TODO: implement toSet
    throw UnimplementedError();
  }

  @override
  Iterable where(bool Function(dynamic element) test) {
    // TODO: implement where
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    throw UnimplementedError();
  }

}