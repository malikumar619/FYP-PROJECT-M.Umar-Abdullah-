import 'dart:io';
import 'package:flutter/material.dart';

class AccidentsCarImageProvider extends ChangeNotifier {
  final List<File> _images = [];
  final List<File> _videos = [];

  List<File> get images => _images;
  List<File> get videos => _videos;

  void addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void addVideo(File video) {
    _videos.add(video);
    notifyListeners();
  }

  void clearAll() {
    _images.clear();
    _videos.clear();
    notifyListeners();
  }
}
