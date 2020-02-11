import 'dart:collection';

import 'package:file_explorer/providers/directory_provider.dart';
import 'package:file_explorer/utils/explorer_item_utils.dart';
import 'package:file_explorer/widgets/explorer_item.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:permission/permission.dart';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';

class DirectoryScreen extends StatefulWidget {
  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    final dirProvider = Provider.of<DirectoryProvider>(context);
    log('Current directory: ${dirProvider.currentDirectory}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black38),
          onPressed: () {
            var baseName = basename(dirProvider.currentDirectory);
            if (dirProvider.currentDirectory != ROOT_DIRECTORY) {
              dirProvider.openNewDirectory(
                  dirProvider.currentDirectory.replaceAll('/$baseName', ''));
            }
          },
        ),
        elevation: 0,
        title: Text(
          dirProvider.currentDirectory,
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.create_new_folder),
                  onPressed: () {
                    dirProvider.createNewDirectory();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            preferredSize: Size(200, 30)),
      ),
      body: Center(
          child: ListView.builder(
        key: new PageStorageKey(dirProvider.currentDirectory),
        itemBuilder: (context, position) {
          io.FileSystemEntity item = dirProvider.items[position];
          print(dirProvider.selected);
          return ExplorerItem(
            item: item,
            onPressed: () {
              if (dirProvider.isSelected(item)) {
                dirProvider.toggleSelectItem(item);
              } else {
                dirProvider.openNewDirectory(
                    dirProvider.currentDirectory + '/' + getItemName(item));
              }
            },
            onLongPress: () {
              dirProvider.toggleSelectItem(item);
            },
            selected: dirProvider.isSelected(item),
          );
        },
        itemCount: dirProvider.items.length,
      )),
    );
  }
}
