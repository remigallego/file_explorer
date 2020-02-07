import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:intl/intl.dart';

bool isDirectory(io.FileSystemEntity item) {
  return item.toString().split(":")[0] == "Directory";
}

bool isFile(io.FileSystemEntity item) {
  return item.toString().split(":")[0] != "Directory";
}

String getItemName(io.FileSystemEntity item) {
  return basename(item.path);
}

// TODO: Refactor to custom implementation: Use library to handle dates better ?
String formatTime(String iso) {
  DateTime date = DateTime.parse(iso);
  DateTime yDay = DateTime.now().subtract(Duration(days: 1));
  DateTime dateFormat = DateTime.parse(
      "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}T00:00:00.000Z");
  DateTime today = DateTime.parse(
      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, "0")}-${DateTime.now().day.toString().padLeft(2, "0")}T00:00:00.000Z");
  DateTime yesterday = DateTime.parse(
      "${yDay.year}-${yDay.month.toString().padLeft(2, "0")}-${yDay.day.toString().padLeft(2, "0")}T00:00:00.000Z");

  if (dateFormat == today) {
    return "Today ${DateFormat("HH:mm").format(DateTime.parse(iso))}";
  } else if (dateFormat == yesterday) {
    return "Yesterday ${DateFormat("HH:mm").format(DateTime.parse(iso))}";
  } else {
    return "${DateFormat("MMM dd, HH:mm").format(DateTime.parse(iso))}";
  }
}
