import 'package:flutter/material.dart';

void scrollToTop(ScrollController _scrollController){
  _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
}