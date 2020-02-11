import 'dart:developer';

import 'package:file/file.dart';
import 'package:file_explorer/providers/directory_provider.dart';
import 'package:file_explorer/utils/explorer_item_utils.dart' as FileUtils;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerItem extends StatefulWidget {
  ExplorerItem(
      {Key key, this.item, this.onPressed, this.onLongPress, this.selected})
      : super(key: key);

  final io.FileSystemEntity item;
  final Function onPressed;
  final Function onLongPress;
  final bool selected;

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

  @override
  Widget build(context) {
    String filename = FileUtils.getItemName(widget.item);

    return MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (FileUtils.isDirectory(widget.item)) {
            widget.onPressed();
          } else {
            OpenFile.open(widget.item.path);
          }
        },
        onLongPress: () {
          widget.onLongPress();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: widget.selected ? Colors.blue : Colors.transparent,
          ),
          child: Row(
            children: <Widget>[
              Container(
                child: renderIcon(),
              ),
              Flexible(
                child: ListTile(
                  title: Text(
                    filename,
                    style: TextStyle(
                        fontSize: 16,
                        color: widget.selected ? Colors.white : Colors.black),
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
