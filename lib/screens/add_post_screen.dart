// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_app/providers/user_provider.dart';
import 'package:flutter_instagram_app/resources/firestore_methods.dart';
import 'package:flutter_instagram_app/utils/colors.dart';
import 'package:flutter_instagram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Using Provider: It will make just one call to Database that's why useful.
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.phototUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.getUser.phototUrl),
                    ),
                    // ignore: duplicate_ignore
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      // ignore: prefer_const_constructors
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            // ignore: prefer_const_constructors
                            image: DecorationImage(
                              // ignore: prefer_const_constructors
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 2,
                  color: primaryColor,
                )
              ],
            ),
          );
  }
}
