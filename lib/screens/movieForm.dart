import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/backend/Database/storage_service.dart';

import 'home.dart';

class MovieForm extends StatefulWidget {
  const MovieForm({Key? key}) : super(key: key);

  @override
  State<MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  TextEditingController name = TextEditingController();
  TextEditingController director = TextEditingController();
  String? posterURL;
  bool upload = false;
  bool loading = false;

  final _formkey = GlobalKey<FormState>();

  final store = PosterUpload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 90, horizontal: 30),
          child: Form(
            key: _formkey,
            child: Column(children: [
              TextFormField(
                controller: name,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Movie Name",
                    labelText: "Movie Name"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: director,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Director's Name",
                    labelText: "Directed By"),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.image,
                  );
                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No File Selected...")));
                    return null;
                  }

                  final path = results.files.single.path;
                  final fileName = results.files.single.name;
                  setState(() {
                    loading = true;
                  });
                  posterURL = await store.uploadFile(path!, fileName);
                  print(posterURL);
                  setState(() {
                    upload = true;
                    loading = false;
                  });
                },
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : DottedBorder(
                        dashPattern: [10, 10],
                        color: upload ? Colors.transparent : Colors.grey,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Center(
                            child: Text(
                                upload ? "Poster Uploaded" : "Upload Poster",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color:
                                        upload ? Colors.white : Colors.black)),
                          ),
                          decoration: BoxDecoration(
                            color: upload ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 300),
              GestureDetector(
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    final firestoreUpload = MovieMethods();
                    await firestoreUpload.upload(
                        name.text, director.text, posterURL!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Movie added')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  // ignore: sort_child_properties_last
                  child: const Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                      border: Border.all(color: Colors.grey)),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
