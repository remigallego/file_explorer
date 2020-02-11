import 'dart:collection';
import 'dart:developer';
import 'dart:io' as io;
import 'package:flutter/material.dart';

const String ROOT_DIRECTORY = "/storage/emulated/0";

class DirectoryProvider with ChangeNotifier {
  final List<io.FileSystemEntity> _items =
      io.Directory(ROOT_DIRECTORY).listSync();

  String currentDirectory = ROOT_DIRECTORY;
  final List<String> _selected = [];

  /// An unmodifiable view of the items in the directory.
  UnmodifiableListView<io.FileSystemEntity> get items =>
      UnmodifiableListView(_items);
  UnmodifiableListView<String> get selected => UnmodifiableListView(_selected);

  void openNewDirectory(String dir) {
    currentDirectory = dir;
    _selected.clear();
    setItems();
  }

  void createNewDirectory() async {
    await io.Directory(currentDirectory + '/fdfds').create(recursive: false);
    setItems();
  }

  void setItems() {
    _items.clear();
    _items.addAll(io.Directory(currentDirectory).listSync());
    notifyListeners();
  }

  void toggleSelectItem(io.FileSystemEntity item) {
    if (_selected.indexOf(item.path) != -1) {
      _selected.remove(item.path);
    } else {
      _selected.add(item.path);
    }
    notifyListeners();
  }

  bool isSelected(io.FileSystemEntity item) {
    if (_selected.indexOf(item.path) != -1) {
      return true;
    } else {
      return false;
    }
  }
}
