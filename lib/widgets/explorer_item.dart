import 'dart:developer';

import 'package:file/file.dart';
import 'package:file_explorer/utils/explorer_item_utils.dart' as FileUtils;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class ExplorerItem extends StatefulWidget {
  ExplorerItem({Key key, this.item, this.openNewFolder}) : super(key: key);

  final io.FileSystemEntity item;
  final Function openNewFolder;

  @override
  _ExplorerItemState createState() => _ExplorerItemState();
}

class _ExplorerItemState extends State<ExplorerItem> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
  }

  Widget renderIcon() {
    if (FileUtils.isDirectory(widget.item)) {
      return Icon(
        Icons.folder,
        color: Colors.orangeAccent,
        size: 40,
      );
    }
    return Icon(
      Icons.insert_drive_file,
      color: Colors.black,
      size: 40,
    );
  }

  Widget renderSubTitle() {
    if (!FileUtils.isDirectory(widget.item) && widget.item != null) {
      return Text(
        /* "${FileUtils.formatBytes(file == null ? 678476 : File(file.path).lengthSync(), 2)}," */
        " ${FileUtils.formatTime(io.File(widget.item.path).lastModifiedSync().toIso8601String())}",
      );
    }
  }

  BoxDecoration renderContainerDecoration() {
    if (_selected) {
      return BoxDecoration(
          color: Colors.blue, border: Border.all(color: Colors.grey[100]));
    } else
      return BoxDecoration(border: Border.all(color: Colors.grey[100]));
  }

  @override
  Widget build(context) {
    String filename = FileUtils.getItemName(widget.item);

    return GestureDetector(
        onTap: () {
          if (FileUtils.isDirectory(widget.item)) {
            widget.openNewFolder();
          } else {
            OpenFile.open(widget.item.path);
          }
        },
        onDoubleTap: () {
          if (FileUtils.isFile(widget.item)) {}
        },
        onLongPress: () {
          print('Long press');
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: _selected ? Colors.blue : Colors.transparent,
              border: Border.all(color: Colors.grey[100])),
          child: Row(
            children: <Widget>[
              Container(
                child: renderIcon(),
                padding: EdgeInsets.only(right: 15),
              ),
              Flexible(
                child: ListTile(
                  title: Text(
                    filename,
                    style: TextStyle(
                        fontSize: 24,
                        color: _selected ? Colors.white : Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: renderSubTitle(),
                ),
              )
            ],
          ),
        ));
  }
}
