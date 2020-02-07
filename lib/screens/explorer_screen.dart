import 'package:file_explorer/utils/explorer_item_utils.dart';
import 'package:file_explorer/widgets/explorer_item.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:mime_type/mime_type.dart';

const ROOT_DIRECTORY = "/storage/emulated/0";

class ExplorerScreen extends StatefulWidget {
  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String _currentDirectory = ROOT_DIRECTORY;
  List<io.FileSystemEntity> _items = [];
  final ScrollController _listViewController = ScrollController();

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
    setState(() {
      _currentDirectory = ROOT_DIRECTORY;
    });
    getItems();
  }

  openNewFolder(String folderPath) {
    void resetScroll() {
      _listViewController.animateTo(
        0.0,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 1),
      );
    }

    setState(() {
      _currentDirectory = folderPath;
    });
    resetScroll();

    getItems();
  }

  handleTap(io.FileSystemEntity item) {
    if (isDirectory(item)) {
      openNewFolder(_currentDirectory + '/' + getItemName(item));
    }
  }

  getItems() {
    setState(() {
      _items = io.Directory(_currentDirectory).listSync();
    });
  }

  ListView renderItems() {
    return ListView.builder(
      controller: _listViewController,
      itemBuilder: (context, position) {
        io.FileSystemEntity item = _items[position];
        print(item);
        return ExplorerItem(
          item: item,
          openNewFolder: () {
            openNewFolder(_currentDirectory + '/' + getItemName(item));
          },
        );
      },
      itemCount: _items.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    log('Current directory: $_currentDirectory');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[200]),
          onPressed: () => {
            setState(() {
              var baseName = basename(_currentDirectory);
              if (_currentDirectory != ROOT_DIRECTORY) {
                openNewFolder(_currentDirectory.replaceAll('/$baseName', ''));
              }
            })
          },
        ),
        elevation: 0,
        title: Text(
          _currentDirectory,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(child: renderItems()),
    );
  }
}
