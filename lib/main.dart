import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(Basics());
}

class Basics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class Album {
  int userId;
  int id;
  String title;
  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  Album.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'];
  toString() => 'Album(userId: $userId, id: $id, title: $title)';
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<List<Album>> futureAlbum;
  Future<List<Album>> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List<Album> loAlbums =
          List.from(jsonDecode(response.body).map((e) => Album.fromJson(e)));
      print(Album.fromJson);
      loAlbums.forEach((e) => print(e.toString()));
      //print(loAlbums);
      return loAlbums;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://miro.medium.com/max/838/1*6Xv45dITe7EMEX9MMxyQ0g.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),

        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Album> albums = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: albums.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Text(albums[index].title),
                        Text(albums[index].id.toString()),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CupertinoActivityIndicator();
            },
          ),
        ),

        //
      ]),
    );
  }
}
