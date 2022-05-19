import 'package:flutter/material.dart';

import '../backend/Database/storage_service.dart';
import '../widgets/movie_tile.dart';

class GuestHome extends StatefulWidget {
  const GuestHome({Key? key}) : super(key: key);

  @override
  State<GuestHome> createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  Stream? movieStream;
  final movieMethods = MovieMethods();

  @override
  void initState() {
    movieMethods.getAllMovies().then((value) {
      setState(() {
        movieStream = value;
      });
    });
    super.initState();
  }

  Widget MovieList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: movieStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MovieTile(
                        name: snapshot.data.docs[index].data()["name"],
                        date: snapshot.data.docs[index].data()["date"],
                        director:
                            snapshot.data.docs[index].data()["directed by"],
                        postID: snapshot.data.docs[index].data()["postID"],
                        posterURL:
                            snapshot.data.docs[index].data()["posterURL"],
                        time: snapshot.data.docs[index].data()["time"],
                        guest: true);
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Movies App"),
      ),
      body: MovieList(),
    );
  }
}
