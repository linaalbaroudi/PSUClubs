import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:firebase_core/firebase_core.dart';

class AddClub extends StatelessWidget {
  static const routeName = '/AddClub-view';
  AddClub({this.user});
  final Faculty user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize:  Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text('Add Club Form'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddClubView(user: this.user),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class AddClubView extends StatefulWidget {
  AddClubView({this.user, this.app});
  final Faculty user;
  final FirebaseApp app;
  @override
  _AddClubViewState createState() => new _AddClubViewState();
}

class _AddClubViewState extends State<AddClubView> {
  void initState() {
    super.initState();
    getArgs(widget.user);
  }

  Faculty passedUser;
  Club _club;
  FirebaseApp passedapp;

  void getArgs(Faculty att2) {
    passedUser = att2;
    _club = new Club(passedUser, "", null, "");
    //passedapp=app;
  }

  final _clubFormKey = GlobalKey<FormState>();
  final _controller_title = new TextEditingController();
  final _controller_description = new TextEditingController();

  //InputDecoration
  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  // manage image input
  io.File image;
  String _imageURL;
  Future getImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = io.File(pickedImage.path);
        _club.logo = _imageURL;
      } else {
        print('No image selected.');
      }
    });
  }
  // acknowledgement
  bool acknowledgement = false;

  @override
  Widget build(BuildContext context) {
    // _club.leader = passedUser;

    return Form(
      key: _clubFormKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: <Widget>[
                  // club title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: _controller_title,
                      decoration: _inputDecoration('Title'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Club Title';
                        } else
                          return null;
                      },
                      onSaved: (val) => setState(() => _club.title = val),
                    ),
                  ),

                  // club logo input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 80.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            margin: EdgeInsets.only(right: 12),
                            child: image == null
                                ? Text('\n     logo')
                                : Image.file(image),
                          ),
                          Expanded(
                            child: FloatingActionButton(
                              onPressed: getImage,
                              tooltip: 'Pick Image',
                              child: Icon(Icons.photo_library),
                            ),
                          ),
                        ]),
                  ),

                  // Description input - done
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _controller_description,
                      decoration: _inputDecoration('Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter club description';
                        } else
                          return null;
                      },
                      onSaved: (val) => setState(() => _club.description = val),
                    ),
                  ),

                  // acknowledgement checkbox
                  FormField(
                    initialValue: false,
                    validator: (value) {
                      if (value == false) {
                        return '               Please make an acknowledge.';
                      }
                      return null;
                    },
                    builder: (FormFieldState formFieldState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: acknowledgement,
                                onChanged: (value) {
                                  // When the value of the checkbox changes,
                                  // update the FormFieldState so the form is
                                  // re-validated.
                                  formFieldState.didChange(value);
                                  setState(() {
                                    acknowledgement = value;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'I acknowledge that the added club meets PSU regulations and standards.',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            ],
                          ),
                          if (!formFieldState.isValid)
                            Text(
                              formFieldState.errorText ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                  color: Theme.of(context).errorColor),
                            ),
                        ],
                      );
                    },
                  ),

                  // submit
                  Container(
                    width: 300,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xff1A033D),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          final form = _clubFormKey.currentState;
                          if (image == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Please Pick an image first")));
                            return;
                          }
                          if (form.validate()){
                            if (mounted){
                              setState(() {
                                void saveForm() async{
                                  form.save();
                                  final referenceTRG = FirebaseStorage.instance
                                      .ref()
                                      .child("images");
                                  await referenceTRG
                                      .child(_club.title + "_logo.jpg")
                                      .putFile(image);
                                  final url = await referenceTRG.child(_club.title + "_logo.jpg").getDownloadURL();
                                  _imageURL= url;
                                  _club.logo = _imageURL;

                                  _club.save();
                                  //  = _imageURL;
                                  _showDialog(context);
                                  _controller_title.clear();
                                  _controller_description.clear();
                                }
                                saveForm();
                              });
                            }

                            //  _club.logo = _imageURL;

                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Added Club Successfully!')));
  }
}
