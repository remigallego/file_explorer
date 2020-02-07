import 'dart:developer';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class ExplorerItemType {
  FileSystemEntityType type;
  String fileName;
}

class ExplorerItem extends StatefulWidget {
  ExplorerItem({Key key, this.item, this.onDoubleTap}) : super(key: key);

  final ExplorerItemType item;
  final Function onDoubleTap;

  @override
  _ExplorerItemState createState() => _ExplorerItemState();
}

class _ExplorerItemState extends State<ExplorerItem> {
  FileSystemEntityType _type;

  void setItemType() async {
    var type = await io.FileSystemEntity.type(widget.item.fileName);
    setState(() {
      _type = type;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    String filename = basename(widget.item.fileName);

    return GestureDetector(
        onDoubleTap: () {
          widget.onDoubleTap();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[100])),
          child: Row(
            children: <Widget>[
              Container(
                  width: 100,
                  child: Text(
                    widget.item.type.toString(),
                    style: TextStyle(fontSize: 20),
                  )),
              Flexible(
                child: Container(
                  child: Text(
                    filename,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
