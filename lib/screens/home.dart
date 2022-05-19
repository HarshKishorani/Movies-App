import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:movies_app/backend/Database/storage_service.dart';
import 'package:movies_app/screens/movieForm.dart';
import 'package:movies_app/widgets/movie_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? movieStream;
  final movieMethods = MovieMethods();
  bool guest = true;

  @override
  void initState() {
    movieMethods.getAllMovies().then((value) {
      setState(() {
        movieStream = value;
      });
    });
    super.initState();
  }

  MovieList() {
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
                        guest: guest);
                  },
                );
        },
      ),
    );
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Movies App"),
        actions: const [SignOutButton()],
      ),
      floatingActionButton: FloatingActionButton(
        //heroTag: "Add Movie",
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MovieForm()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      // ignore: prefer_const_literals_to_create_immutables
      bottomNavigationBar: BottomNavigationBar(
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "All Movies",
                backgroundColor: Colors.blue),
            const BottomNavigationBarItem(
                icon: Icon(Icons.more),
                label: "My Movies",
                backgroundColor: Colors.blue),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: (index) async {
            index == 0
                ? await movieMethods.getAllMovies().then((value) {
                    setState(() {
                      movieStream = value;
                      _selectedIndex = index;
                      guest = true;
                    });
                  })
                : await movieMethods.getUserMovies().then((value) {
                    setState(() {
                      movieStream = value;
                      _selectedIndex = index;
                      guest = false;
                    });
                  });
          },
          elevation: 5),
      body: MovieList(),
    );
  }
}
