import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  num totalCount = 0;
  List<dynamic> collectionList = [
    {
      "id": "159",
      "workspace_id": "this_is_an_id65_that_should_be_at_least_4",
      "name": "How-to English Collection",
      "url": "http://help-center.test/myapp-65/collection-17",
      "order": 17,
      "created_at": "20.12.2023",
      "description": "This is the english collection of the How-to Articles inside our Help Center.",
      "icon": "bookmark",
      "parent_id": null,
      "help_center_id": 79
    },
    {
      "id": "160",
      "workspace_id": "this_is_an_id65_that_should_be_at_least_4",
      "name": "My #1 Test Collection",
      "url": "http://help-center.test/myapp-65/section-1",
      "order": 1,
      "created_at": "12.05.2024",
      "description": "This is the first collection I ever created.",
      "icon": "bookmark",
      "parent_id": "159",
      "help_center_id": null
    },
    {
      "id": "160",
      "workspace_id": "this_is_an_id65_that_should_be_at_least_4",
      "name": "English Image Components Collection",
      "url": "http://help-center.test/myapp-65/section-1",
      "order": 1,
      "created_at": "06.07.2024",
      "description": "This is the collection for image components of all english articles, inside the Help Center.",
      "icon": "bookmark",
      "parent_id": "159",
      "help_center_id": null
    },
    {
      "id": "159",
      "workspace_id": "this_is_an_id65_that_should_be_at_least_4",
      "name": "How-to German Collection",
      "url": "http://help-center.test/myapp-65/collection-17",
      "order": 17,
      "created_at": "18.07.2024",
      "description": "This is the german collection of the How-to Articles inside our Help Center.",
      "icon": "bookmark",
      "parent_id": null,
      "help_center_id": 79
    },
  ];

  @override
  void initState() {
    super.initState();

    getApiData();
  }

  Future<void> getApiData() async {
    final uri = Uri.https("api.intercom.io", "/help_center/collections");
    final response = await Client().get(
      uri,
      headers: {
        "Intercom-Version": "2.11",
        "Authorization": 'Bearer ${dotenv.env['APP_TOKEN'] ?? 'X'}',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData["data"]) {
        collectionList = jsonData["data"] as List<dynamic>;
        totalCount = jsonData["totalCount"] as num;
      }
    } else {
      debugPrint("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          height: screenHeight / 10,
          width: screenWidth / 1.25,
          margin: EdgeInsets.symmetric(vertical: screenHeight / 15),
          alignment: Alignment.center,
          child: Text(
            "Your Collections",
            style: GoogleFonts.inter(
              color: Colors.redAccent,
              fontSize: 50,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        ListView.separated(
          itemCount: collectionList.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: screenHeight / 25),
          itemBuilder: (context, index) {
            return Container(
              height: screenHeight / 8,
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 10),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                border: Border.all(width: 5.0, color: Colors.black.withOpacity(0.25)),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          collectionList[index]["name"],
                          style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          collectionList[index]["description"],
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(top: 0, right: 0, child: Text(collectionList[index]["created_at"]))
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
