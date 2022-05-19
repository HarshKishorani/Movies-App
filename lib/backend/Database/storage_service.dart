import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class PosterUpload {
  final storage = FirebaseStorage.instance;
  Future<String?> uploadFile(String path, String fileName) async {
    File file = File(path);
    try {
      await storage.ref("posters/$fileName").putFile(file);
      return await storage.ref("posters/$fileName").getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

class MovieMethods {
  Future<void> upload(String name, String director, String posterURL) async {
    final now = DateTime.now();
    final String postID = randomAlphaNumeric(16);

    Map<String, String> data = {
      "name": name,
      "directed by": director,
      "posterURL": posterURL,
      "date": DateFormat.yMd().format(now),
      "time": DateFormat.jm().format(now),
      "postID": postID,
    };
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .doc(postID)
        .set(data)
        .catchError((e) {
      print(e.toString());
    });

    //? Upload in realtime database
    await FirebaseFirestore.instance
        .collection("AllPosts")
        .doc(postID)
        .set(data);
  }

  //? Get Movies made by the user.
  getUserMovies() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .snapshots();
  }

  updateMovie(
      String name, String postID, String posterURL, String director) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .doc(postID)
        .update({
      "name": name,
      "directed by": director,
      "posterURL": posterURL,
    });

    //TODO: Update for Realtime Database
  }

  deleteMovie(String postID) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Posts")
        .doc(postID)
        .delete();

    await FirebaseFirestore.instance
        .collection("AllPosts")
        .doc(postID)
        .delete();
  }

  getAllMovies() async {
    return await FirebaseFirestore.instance.collection("AllPosts").snapshots();
  }
}
