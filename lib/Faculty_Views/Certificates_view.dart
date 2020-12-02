import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:gx_file_picker/gx_file_picker.dart';
import 'dart:io';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Certificate.dart';
import 'package:psu_club/Models/Faculty.dart';

class CertificateView extends StatelessWidget {
  static const routeName = '/CertificateView';
  CertificateView({this.user});
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
            title: Text(' Upload Certificate Form'),
          ),
        ),
        body: Center(
          child: CertificateForm(user: this.user),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class CertificateForm extends StatefulWidget {
  CertificateForm({this.user});
  final Faculty user;
  @override
  _CertificateFormState createState() => _CertificateFormState();
}

class _CertificateFormState extends State<CertificateForm> {
  // passed data
  Faculty _passedUser;
  final _certificateFormKey = GlobalKey<FormState>();
  // object to submit
  Certificates _cert;
  // date variables
  DateTime pickedDate = DateTime.now();
  final format = intl.DateFormat("HH:mm");

  // controllers
  final _controller_stid = new TextEditingController();
  final _controller_title = new TextEditingController();

  void initState() {
    super.initState();
    getArgs(widget.user);
  }

  void getArgs(Faculty att2) {
    _passedUser = att2;
    _cert = new Certificates(_passedUser.userID,'' , '', '', '');
    _cert.file= new File('');
  }

  Future getFile() async {
    FilePicker.clearTemporaryFiles();
    File _pickedFile = await FilePicker.getFile();
    setState(() {
      if(_pickedFile == null){
        _cert.file= new File('');
      }else{
        //print(_pickedFile);
        _cert.file = _pickedFile;
      }

    });
  }

// // to delete
//   Text displayFileName(File _file) {
//     if (_file != null)
//       return Text(
//         _file.toString(),
//       );
//     return Text(
//       '\n   Insert Certificate',
//       style: TextStyle(
//         fontSize: 15,
//         color: Colors.grey,
//       ),
//     );
//   }
//
//   void uploadFile()async {
//
//   }

  void _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }

  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  @override
  Widget build(BuildContext context) {
    // file variables
   // File _file = new File('');
    //String _fileURL;
    return Form(
        key: _certificateFormKey,
        child: Scrollbar(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //file
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 250,
                                height: 50,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: (_cert.file.path=='') ? Text('\n   Insert Certificate',style: TextStyle(fontSize: 15,color: Colors.grey,)) : Text(_cert.file.path),
                              ),


                              SizedBox(
                                width: 20,
                              ),
                              FloatingActionButton(
                                onPressed: getFile,
                                backgroundColor: Color(0xff1A033D),
                                tooltip: 'Pick Certificate',
                                child: Icon(Icons.file_upload),
                              ),
                            ],
                          ),
                        ),
                        //stid
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 18.0),
                          child: TextFormField(
                            controller: _controller_stid,
                            decoration: _inputDecoration('Student ID'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Student ID';
                              } else
                                return null;
                            },
                            onSaved: (val) =>
                                setState(() => _cert.studentID = val),
                          ),
                        ),
                        //date earned
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 18.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: _FormDatePicker(
                                  date: pickedDate,
                                  onDateChanged: (value) {
                                    setState(() {
                                      String d = intl.DateFormat.yMd()
                                          .format(value)
                                          .toString();
                                      pickedDate = value;
                                      _cert.date = d;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        // name of event
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 18.0),
                          child: TextFormField(
                            controller: _controller_title,
                            decoration:
                            _inputDecoration('Name of event or workshop'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter name of event or workshop';
                              } else
                                return null;
                            },
                            onSaved: (val) => setState(() => _cert.title = val),
                          ),
                        ),
                        //button
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
                                final form = _certificateFormKey.currentState;
                                if (_cert.file.path=='') {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Please Pick a certificate file first")));
                                  return;
                                }
                                if (form.validate()) {
                                  if (mounted) {
                                    setState(() {
                                      void saveForm() async {
                                        form.save();
                                        final referenceSTRG = FirebaseStorage.instance.ref().child("certificates/");
                                        final String fileName = _cert.studentID + "_" + _cert.title +'.pdf';
                                        await referenceSTRG.child(fileName).putFile(_cert.file);
                                        final downloadUrl =  await referenceSTRG.child(fileName).getDownloadURL();
                                        print(downloadUrl);
                                        _cert.setURL = downloadUrl;

                                        _cert.save();
                                        _showDialog(context);
                                        _controller_stid.clear();
                                        _controller_title.clear();
                                      }

                                      saveForm();
                                    }
                                    ); //setstate
                                  } // if mounted
                                } else print("not valid form");// form validate
                              }),
                        ),
                      ],
                    )))));
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  ValueChanged onDateChanged;

  _FormDatePicker({
    this.date,
    this.onDateChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        FlatButton(
          child: Icon(Icons.calendar_today),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2030),
            );
            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }
            widget.onDateChanged(newDate);
          },
        ),
      ],
    );
  }
}
