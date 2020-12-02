import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';

class AddClubWorkshop extends StatelessWidget {
  static const routeName = '/Addclubworkshop-view';
  AddClubWorkshop({this.exampleClub, this.user});
  final Club exampleClub;
  final Faculty user;

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
                Text('Add Club Workshop'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddWorkshopView(
                  exampleClub: this.exampleClub, user: this.user),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class AddWorkshopView extends StatefulWidget {
  AddWorkshopView({this.exampleClub, this.user, this.app});
  final FirebaseApp app;
  final Club exampleClub;
  final Faculty user;
  @override
  _AddWorkshopViewState createState() => _AddWorkshopViewState();
}

class _AddWorkshopViewState extends State<AddWorkshopView> {
  // passed data
  Club passedClub;
  Faculty passedUser;

  // workshop object to be submitted
  Workshop _workshop;

  // form key
  final _workshopFormKey = GlobalKey<FormState>();

  // controllers for clearing the data on submit
  final _controllerTitle = new TextEditingController();
  final _controllerDescription = new TextEditingController();
  final _controllerLocation = new TextEditingController();
  final _controllerNumOfReg = new TextEditingController();
  // final _controllerVolNumOfReg = new TextEditingController();
  // final _controllerVolDescription = new TextEditingController();
  final _controllerNumOfDays = new TextEditingController();

  //department input options
  final _departmentList = [
    'General event',
    'Business Administration',
    'Computer & Information science',
    'Engineering',
    'Humanities',
    'Law'
  ];
  String department;
  int dates = 1;
  //manage date and time input
  DateTime pickedDate = DateTime.now();
  DateTime pickedTime = DateTime.now();
  final format = intl.DateFormat("HH:mm");

  // manage image input
  io.File _image;
  String _imageURL;

  //adding volunteering positions to the workshop
  bool volPos = false;
  List<String> theseDates;
  List<VolunteeringPosition> theseVP;
  void initState() {
    super.initState();
    getArgs(widget.exampleClub, widget.user);
  }

  void getArgs(Club att1, Faculty att2) {
    passedUser = att2;
    passedClub = att1;
    _workshop = Workshop(null, "", "", "", null, "", "", 0, null);
  }

  //InputDecoration
  _inputDecoration(label) => InputDecoration(
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
        _workshop.poster = _imageURL;
      } else {
        print('No image selected.');
      }
    });
  }

  void changedDropDownItem(value) {
    setState(() {
      this.department = value;
    });
  }

  void _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Club Workshop Added Successfully')));
  }

  Row displayVP(int i, String time, Workshop _workshop, int currentDates) {
    if (theseDates == null) return Row();
    return Row(
      children: <Widget>[
        Text(
          'Date: ' + theseDates[i] + '\n Time: ' + _workshop.time,
        ),
        Expanded(
          child: TextFormField(
              //  controller: _controllerVolNumOfReg,
              decoration: InputDecoration(
                  labelText: 'Seats',
                  hintText: '1',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      borderSide: new BorderSide())),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the number of participants';
                } else {
                  int digitValue = int.parse(value);
                  if (digitValue == null) {
                    return 'Input needs to be digits only';
                  } else {
                    setState(() {
                      //  print(_workshop.volunteeeringOpportunity.length);
                      theseVP[i] = new VolunteeringPosition("VP$i",
                          _workshop.time, theseDates[i], '', digitValue);
                    });
                    return null;
                  }
                }
              }),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: TextFormField(
              //   controller: _controllerVolDescription,
              decoration:
                  _AddWorkshopViewState()._inputDecoration('Description'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter workshop volunteering position';
                } else
                  return null;
              },
              onSaved: (val) {
                theseVP[i].description = val;
              }),
        )
      ],
    );
  }

  Column displayDatePickers(int i, DateTime pickedDate, Workshop _workshop) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                String d = intl.DateFormat.yMd().format(value).toString();
                pickedDate = value;
                theseDates[i] = d;
              });
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  @override
  bool firstTime = false;
  Widget build(BuildContext context) {
    if (_workshop.dates.length > 0 && firstTime == false) {
      _workshop.dates.clear();
      _workshop.volunteeeringOpportunity.clear();
      firstTime = true;
    }
    _workshop.leader = passedUser;
    _workshop.hostingClub = passedClub;
    return Form(
      key: _workshopFormKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              children: <Widget>[
                // title input - done
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    controller: _controllerTitle,
                    decoration: _inputDecoration('Title'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter workshop title';
                      } else
                        return null;
                    },
                    onSaved: (val) => setState(() => _workshop.title = val),
                  ),
                ),
                //number of dates
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    controller: _controllerNumOfDays,
                    onChanged: (value) {
                      setState(() {
                        dates = int.parse(value);
                        theseDates = new List(dates);
                        theseVP = new List(dates);
                        _workshop.dates = new List<String>();
                        _workshop.volunteeeringOpportunity =
                            new List<VolunteeringPosition>();
                      });
                    },
                    decoration: InputDecoration(
                        labelText:
                            'How many days the workshop will take? Enter their dates',
                        hintText: '1',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            borderSide: new BorderSide())),
                    keyboardType: TextInputType.number,
                  ),
                ),
                // date and time input - to check
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < dates; i++)
                        displayDatePickers(i, pickedDate, _workshop),
                    ],
                  ),
                ),

                //time input - to check
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: DateTimeField(
                    decoration: InputDecoration(
                        labelText: 'Time',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            borderSide: new BorderSide())),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      _workshop.time = intl.DateFormat.Hm()
                          .format(DateTimeField.convert(time))
                          .toString();
                      return DateTimeField.convert(time);
                    },
                  ),
                ),

                // location input - done
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    controller: _controllerLocation,
                    decoration: _inputDecoration('Location'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter workshop location';
                      } else
                        return null;
                    },
                    onSaved: (val) => setState(() => _workshop.place = val),
                  ),
                ),

                // poster input
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 100.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 197,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: EdgeInsets.only(right: 12),
                          child: _image == null
                              ? Text('\n   Insert Image')
                              : Image.file(_image),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    controller: _controllerDescription,
                    decoration: _inputDecoration('Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter workshop description';
                      } else
                        return null;
                    },
                    onSaved: (val) =>
                        setState(() => _workshop.description = val),
                  ),
                ),

                ListTile(
                  title: FittedBox(
                    child: Text(
                      "Choose a PSU \ndepartment: ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: DropdownButton(
                    value: department,
                    onChanged: (String newValue) {
                      setState(() {
                        department = newValue;
                        _workshop.department = newValue;
                      });
                    },
                    items: List<String>.from(_departmentList)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                // number of registrants - done
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    controller: _controllerNumOfReg,
                    decoration: _inputDecoration('number of registrants'),
                    keyboardType: TextInputType.number,
                    onSaved: (input) {
                      _workshop.noOfSeats = int.parse(input);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the number of participants';
                      } else {
                        int digitValue = int.parse(value);
                        if (digitValue == null) {
                          return 'Input needs to be digits only';
                        } else
                          setState(() => _workshop.noOfSeats = digitValue);
                        return null;
                      }
                    },
                  ),
                ),

                // add volunteering positions
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: FormField(
                    initialValue: false,
                    validator: (value) {
                      if (value == false) {
                        return 'You must add at least one volunteering position to the workshop';
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
                                value: volPos,
                                onChanged: (value) {
                                  // When the value of the checkbox changes, update the FormFieldState so the form is re-validated.
                                  formFieldState.didChange(value);
                                  setState(() {
                                    volPos = value;
                                    //  print(_workshop.dates.length);
                                  });
                                },
                              ),
                              Text(
                                'Add volunteering position*',
                                style: Theme.of(context).textTheme.subtitle1,
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
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      if (volPos != false && theseDates.isEmpty) Row(),
                      if (volPos != false && theseDates.isNotEmpty)
                        for (int i = 0; i < dates; i++)
                          displayVP(i, _workshop.time, _workshop, dates),
                    ],
                  ),
                ),

                // submit the form input - done
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
                        final form = _workshopFormKey.currentState;
                        if (_image == null) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please Pick an image first")));
                          return;
                        }
                        if (form.validate()) {
                          if (mounted) {
                            setState(() {
                              void _savaForm() async {
                                form.save();
                                // for (int i =0;i<dates;i++){
                                //   _workshop.dates.insert(i,theseDates[i]);
                                //   _workshop.volunteeeringOpportunity.insert(i,theseVP[i]);
                                //   print(_workshop.dates.length);
                                //   print(_workshop.volunteeeringOpportunity.length);
                                // }
                                final referenceTRG = FirebaseStorage.instance
                                    .ref()
                                    .child("images");
                                await referenceTRG
                                    .child(_workshop.title + "_poster.jpg")
                                    .putFile(_image);
                                final _url = await referenceTRG
                                    .child(_workshop.title + "_poster.jpg")
                                    .getDownloadURL();
                                _imageURL = _url;
                                _workshop.poster = _imageURL;
                                _workshop.save(theseDates, theseVP);
                                _showDialog(context);
                                _controllerTitle.clear();
                                _controllerDescription.clear();
                                _controllerLocation.clear();
                                _controllerNumOfReg.clear();
                                // _controllerVolNumOfReg.clear();
                                // _controllerVolDescription.clear();
                                _controllerNumOfDays.clear();
                              }

                              _savaForm();
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
    );
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
              firstDate: DateTime.now(),
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
