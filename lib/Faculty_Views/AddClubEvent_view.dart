import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'Faculty_Drawer.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Event.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';

class AddClubEvent extends StatefulWidget {
  static const routeName = '/Addclubevent-view';
  final FirebaseApp app;
  AddClubEvent({this.exampleClub, this.user, this.app});
  final Faculty user;
  final Club exampleClub;
  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddClubEvent> {
  // passed data
  Club passedClub;
  Faculty passedUser;

  // evant to be submitted
  Event _event;

  // form key
  final _eventFormKey = GlobalKey<FormState>();

  // controllers for clearing the data on submit
  final _controllerTitle = new TextEditingController();
  final _controllerDescription = new TextEditingController();
  final _controllerLocation = new TextEditingController();
  final _controllerNumOfReg = new TextEditingController();
  final _controllerVolNumOfReg = new TextEditingController();
  final _controllerVolDescription = new TextEditingController();

  //department input options
  String department;
  final _departmentList = [
    'General event',
    'Business Administration',
    'Computer & Information science',
    'Engineering',
    'Humanities',
    'Law'
  ];

  //manage date and time input
  DateTime pickedDate = DateTime.now();
  DateTime pickedTime = DateTime.now();
  final format = intl.DateFormat("HH:mm");

  // manage image input
  io.File _image;
  String _imageURL;

  //adding volunteering positions to the event
  bool volPos = false;

  initState() {
    super.initState();
    getArgs(widget.user, widget.exampleClub);
  }

  void getArgs(Faculty att1, Club att2) {
    passedUser = att1;
    passedClub = att2;
    _event =
        new Event(passedUser, "", "", "", "", "", "", 0, passedClub, false);
    _event.dates = new List();
  }

  //InputDecoration
  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  Container displayNumReg(bool enabled, BuildContext contx, Event event) {
    if (enabled) {
      return Container(
        child: TextFormField(
          controller: _controllerNumOfReg,
          decoration: InputDecoration(
              labelText: 'number of registration seats',
              hintText: 'only if registration is enabled',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  borderSide: new BorderSide())),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          onSaved: (input) {
            event.noOfSeats = (int.parse(input));
          },
          validator: (input) {
            final isDigitsOnly = int.tryParse(input);
            return isDigitsOnly == null
                ? 'Input needs to be digits only'
                : null;
          },
        ),
      );
    }
    return Container();
  }

  void changedDropDownItem(value) {
    setState(() {
      this.department = value;
    });
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = io.File(pickedImage.path);
        _event.poster = _imageURL;
      } else {
        print('No image selected.');
      }
    });
  }

  void _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Club Event Added Successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    _event.leader = passedUser;
    _event.hostingClub = passedClub;

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
                Text('Add Club Event Form'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _eventFormKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: <Widget>[
                          // title input
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: TextFormField(
                              controller: _controllerTitle,
                              decoration: _inputDecoration('Title'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter club  Event title';
                                } else
                                  return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _event.title = val),
                            ),
                          ),

                          // date input
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: Container(
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
                                    _event.dates.add(d);
                                  });
                                },
                              ),
                            ),
                          ),

                          // time input
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: DateTimeField(
                              decoration: InputDecoration(
                                  labelText: 'Time',
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      borderSide: new BorderSide())),
                              format: format,
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                _event.time = intl.DateFormat.Hm()
                                    .format(DateTimeField.convert(time))
                                    .toString();
                                return DateTimeField.convert(time);
                              },
                            ),
                          ),

                          // location input
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: TextFormField(
                              controller: _controllerLocation,
                              decoration: _inputDecoration('Location'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter event location';
                                } else
                                  return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _event.place = val),
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
                                  return 'Please enter Event description';
                                } else
                                  return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _event.description = val),
                            ),
                          ),

                          // choose department
                          ListTile(
                            title: Text(
                              "Choose a PSU department: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: DropdownButton(
                              value: department,
                              items: List<String>.from(_departmentList)
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child:
                                      Container(width: 200, child: Text(value)),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  department = newValue;
                                  _event.department = newValue;
                                });
                              },
                            ),
                          ),

                          //enable registration
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SwitchListTile(
                              title: Text("Enable Registration",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              value: _event.registrationStatus,
                              onChanged: (bool val) => setState(
                                  () => _event.registrationStatus = val),
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.green,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red,
                            ),
                          ),

                          // number of registration seats
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: displayNumReg(
                                _event.registrationStatus, context, _event),
                          ),

                          // add volunteering positions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: FormField(
                              initialValue: false,
                              validator: (value) {
                                if (value == false) {
                                  return 'You must add at least one volunteering position to the Event';
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
                                            });
                                          },
                                        ),
                                        Text(
                                          'Add volunteering position*',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
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
                                                color: Theme.of(context)
                                                    .errorColor),
                                      ),
                                    if (volPos != false && _event.dates.isEmpty)
                                      Row(),
                                    if (volPos != false &&
                                        _event.dates.isNotEmpty)
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Date: ' +
                                                _event.dates[0] +
                                                '\nTime: ' +
                                                _event.time,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _controllerVolNumOfReg,
                                              decoration: InputDecoration(
                                                  labelText: 'Seats',
                                                  hintText: '1',
                                                  fillColor: Colors.white,
                                                  border: new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(18.0),
                                                      borderSide:
                                                          new BorderSide())),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter the number of participants';
                                                } else {
                                                  int digitValue =
                                                      int.parse(value);
                                                  if (digitValue == null) {
                                                    return 'Input needs to be digits only';
                                                  } else {
                                                    //VolunteeringPosition(this._time, this._date, this._description,
                                                    //       this._numberOfPositions, this._registrationStatus);

                                                    setState(() => _event
                                                        .volunteeeringOpportunity
                                                        .add(
                                                            new VolunteeringPosition(
                                                                "VP0",
                                                                _event.time,
                                                                _event.dates[0],
                                                                '',
                                                                digitValue)));
                                                    return null;
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller:
                                                  _controllerVolDescription,
                                              decoration: _inputDecoration(
                                                  'Description'),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter event volunteering position';
                                                } else
                                                  return null;
                                              },
                                              onSaved: (val) => setState(() =>
                                                  _event
                                                      .volunteeeringOpportunity[
                                                          0]
                                                      .description = val),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                );
                              },
                            ),
                          ),

                          // submit the form input
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
                                  final form = _eventFormKey.currentState;
                                  if (_image == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "Please Pick an image first")));
                                    return;
                                  }
                                  if (form.validate()) {
                                    if (mounted) {
                                      setState(() {
                                        void _saveForm() async {
                                          form.save();
                                          final referenceTRG = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child("images");
                                          await referenceTRG
                                              .child(
                                                  _event.title + "_poster.jpg")
                                              .putFile(_image);
                                          final _url = await referenceTRG
                                              .child(
                                                  _event.title + "_poster.jpg")
                                              .getDownloadURL();
                                          _imageURL = _url;
                                          _event.poster = _imageURL;
                                          _event.saveClubEvents();
                                          _showDialog(context);
                                          _controllerTitle.clear();
                                          _controllerDescription.clear();
                                          _controllerLocation.clear();
                                          _controllerNumOfReg.clear();
                                          _controllerVolNumOfReg.clear();
                                          _controllerVolDescription.clear();
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
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: passedUser),
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
