import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMap {
  static const List<Map<String, dynamic>> menu = [
    {"title": "Home", "icon": FontAwesomeIcons.house, "path": "/test_widget", "children": []},
    {"title": "Articles", "icon": FontAwesomeIcons.newspaper, "path": "/test_widget", "children": []},
    {"title": "Links", "icon": FontAwesomeIcons.link, "path": "/test_widget", "children": []},
    {
      "title": "Social Media",
      "icon": FontAwesomeIcons.hashtag,
      "children": [
        {"title": "Facebook", "icon": FontAwesomeIcons.squareFacebook, "path": "/test_widget", "children": []},
        {"title": "Twitter/X", "icon": FontAwesomeIcons.squareXTwitter, "path": "/test_widget", "children": []},
        {"title": "Snapchat", "icon": FontAwesomeIcons.squareSnapchat, "path": "/test_widget", "children": []},
      ]
    },
    {"title": "Settings", "icon": FontAwesomeIcons.gear, "path": "/test_widget", "children": []},
  ];
}
