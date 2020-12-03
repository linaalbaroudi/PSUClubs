import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class EditClub_View extends StatelessWidget {
  static const routeName = '/EditClub';
  EditClub_View({this.user, this.passedClub});
  final Faculty user;
  final Club passedClub;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
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
                Text('Edit Club Form'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditClub(user: this.user, passedClub: this.passedClub),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}
Image displayImage(io.File image, Club passedClub){
  if ( image==null)
    return Image.network(passedClub.logo,
      height: 150,
      width: 150,
      fit: BoxFit.fill);
  else
    return Image.file(image);
}
class EditClub extends StatefulWidget {
  EditClub({this.user, this.app, this.passedClub});
  final Faculty user;
  final FirebaseApp app;
  final Club passedClub;
  @override
  _EditClubState createState() => _EditClubState();
}

class _EditClubState extends State<EditClub> {
  // passed data
  Faculty _passedUser;
  Club _passedClub;
  Club _newClub;

  // controllers for clearing the data on submit
  final _clubFormKey = GlobalKey<FormState>();

  String _oldTitle ;

  // manage image input
  io.File _image ;
  String _imageURL;

  // acknowledgement
  bool acknowledgement = false;

  void initState() {
    super.initState();
    getArgs(widget.user, widget.passedClub);
  }

  void getArgs(Faculty att2, Club passedClub) {
    _passedUser = att2;
    _passedClub = passedClub;
    _newClub = _passedClub;
    _oldTitle = _passedClub.title;
  }

  //InputDecoration
  _inputDecoration(label) =>
      InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(18.0),
              borderSide: new BorderSide()));

  Future getImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = io.File(pickedImage.path);
        _newClub.logo = _imageURL;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      initialValue: _passedClub.title,
                      //     controller: _controllerTitle,
                      decoration: _inputDecoration('Title'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Club Title';
                        } else
                          return null;
                      },
                      onSaved: (val) => setState(() => _newClub.title = val),
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
                            child: displayImage(_image,_passedClub),
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

                  // Description input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: _passedClub.description,
                      //       controller: _controllerDescription,
                      decoration: _inputDecoration('Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter club description';
                        } else
                          return null;
                      },
                      onSaved: (val) =>
                          setState(() => _newClub.description = val),
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
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .subtitle1,
                                ),
                              ),
                            ],
                          ),
                          if (!formFieldState.isValid)
                            Text(
                              formFieldState.errorText ?? "",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                  color: Theme
                                      .of(context)
                                      .errorColor),
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
                          if (form.validate()) {
                            if (mounted) {
                              setState(() {
                                void _saveForm() async {
                                  form.save();
                                  if (_image!=null){
                                    final referenceTRG = FirebaseStorage.instance
                                        .ref()
                                        .child("images");
                                    await referenceTRG
                                        .child(_newClub.title + "_logo.jpg")
                                        .putFile(_image);
                                    final _url =
                                    await referenceTRG.child(_newClub.title + "_logo.jpg").getDownloadURL();
                                    _imageURL = _url;
                                    _newClub.logo = _imageURL;
                                  }
                                  _newClub.saveEdited(_oldTitle);
                                  _showDialog(context);
                                }

                                _saveForm();
                              });
                            }
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

}

  void _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Edited Club Successfully!')));
  }

