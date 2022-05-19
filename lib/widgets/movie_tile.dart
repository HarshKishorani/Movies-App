import 'package:flutter/material.dart';
import 'package:movies_app/screens/edit_movie.dart';

import '../backend/Database/storage_service.dart';

class MovieTile extends StatelessWidget {
  final String name;
  final String posterURL;
  final String postID;
  final String date;
  final String time;
  final String director;
  final bool guest;
  const MovieTile(
      {Key? key,
      required this.name,
      required this.director,
      required this.postID,
      required this.date,
      required this.time,
      required this.posterURL,
      required this.guest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [const BoxShadow(blurRadius: 3)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 120,
            //height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(posterURL),
            ),
          ),
          Container(
            height: 160,
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text("Directed by : $director"),
                Spacer(),
                guest
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditMovie(
                                          Name: name,
                                          director: director,
                                          postID: postID,
                                          posterURL: posterURL)));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 20,
                          ),
                          IconButton(
                            onPressed: () async {
                              final firestoreUpload = MovieMethods();
                              await firestoreUpload.deleteMovie(postID);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Movie deleted')),
                              );
                            },
                            icon: Icon(Icons.delete),
                            iconSize: 20,
                          )
                        ],
                      ),
                Text(date + " " + time)
              ],
            ),
          )
        ],
      ),
    );
  }
}
