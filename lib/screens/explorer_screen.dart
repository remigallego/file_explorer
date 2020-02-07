import 'package:file_explorer/widgets/explorer_item.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
import 'dart:developer';
import 'package:path/path.dart';

const ROOT_DIRECTORY = "/storage/emulated/0";

class ExplorerScreen extends StatefulWidget {
  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String _currentDirectory;
  List<ExplorerItemType> _items = [];

  void setRootDirectory() {
    if (io.Platform.isAndroid) {
      setState(() {
        _currentDirectory = ROOT_DIRECTORY;
      });
    } else {
      setState(() {
        _currentDirectory = ROOT_DIRECTORY;
      });
    }
  }

  handlePermissions() async {
    try {
      log('Handling permissions...');
      await Permission.getPermissionsStatus([PermissionName.Storage])
          .then((List<Permissions> v) {
        print(v[0].permissionStatus);
        if (v[0].permissionStatus == PermissionStatus.deny ||
            v[0].permissionStatus == PermissionStatus.notDecided ||
            v[0].permissionStatus == PermissionStatus.notAgain) {
          Permission.requestPermissions([PermissionName.Storage]).then((d) {
            print(d);
          });
        }
      });
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  @override
  void initState() {
    super.initState();
    handlePermissions();
    setRootDirectory();
    resolveItemsData();
  }

  openNewFolder(item) {
    setState(() {
      _currentDirectory = _currentDirectory + '/' + item.fileName;
    });
    resolveItemsData();
  }

  handleDoubleTap(ExplorerItemType item) async {
    var isDirectory = item.type == io.FileSystemEntityType.directory;
    if (isDirectory) {
      openNewFolder(item);
    }
  }

  resolveItemsData() async {
    log(_currentDirectory);
    var futures = io.Directory(_currentDirectory).listSync().map((item) async {
      var newItem = new ExplorerItemType();
      var type = await io.FileSystemEntity.type(item.path);
      var fileName = basename(item.path);
      newItem.type = type;
      newItem.fileName = fileName;
      return newItem;
    });

    Future.wait(futures).then((e) {
      setState(() {
        _items = e;
      });
    });
  }

  List<Widget> renderFiles() {
    return _items.map((item) {
      return ExplorerItem(
        item: item,
        onDoubleTap: () {
          handleDoubleTap(item);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    log('Current directory: $_currentDirectory');

    /* resolveItemsData(); */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[200]),
          onPressed: () => {
            setState(() {
              var baseName = basename(_currentDirectory);
              log(baseName);
              setState(() {
                if (_currentDirectory != ROOT_DIRECTORY) {
                  _currentDirectory =
                      _currentDirectory.replaceAll('/$baseName', '');
                }
              });
            })
          },
        ),
        elevation: 0,
        title: Text(
          "Explorer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
          child: ListView(
        children: renderFiles(),
      )),
    );
  }
}
