//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:io' as io;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Event.dart' as uniEvent;
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';

class EditUniEvent extends StatefulWidget {
  EditUniEvent({this.user, this.passedEvent});
  final uniEvent.Event passedEvent;
  final Faculty user;
  @override
  _EditUniEventState createState() => _EditUniEventState();
}

class _EditUniEventState extends State<EditUniEvent> {
  // passed data
  Faculty passedUser;
  String oldTitle;
  // event object to be submited
  uniEvent.Event _oldEvent;
  uniEvent.Event _newEvent;

  // form key
  final _eventFormKey = GlobalKey<FormState>();

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
  final format = DateFormat("HH:mm");
  bool changeDate = false;
  bool changeTime = false;
  bool changeRS = false;
  // manage image input
  io.File _image;
  String _imageURL;

  //adding volunteering positions to the event
  bool volPos = false;
  Text showText() {
    if (changeDate && changeTime)
      return Text(
        'Date: ' + _newEvent.dates[0] + '\nTime: ' + _newEvent.time,
      );
    else if (changeDate)
      return Text(
        'Date: ' + _newEvent.dates[0] + '\nTime: ' + _oldEvent.time,
      );
    else if (changeTime)
      return Text(
        'Date: ' + _oldEvent.dates[0] + '\nTime: ' + _newEvent.time,
      );
    else
      return Text(
        'Date: ' + _oldEvent.dates[0] + '\nTime: ' + _oldEvent.time,
      );
  }

  @override
  void initState() {
    super.initState();
    getArgs(widget.user, widget.passedEvent);
  }

  void getArgs(Faculty att1, uniEvent.Event passedEvent) {
    passedUser = att1;
    _oldEvent = passedEvent;
    oldTitle = _oldEvent.title;
    _newEvent = passedEvent;
    _oldEvent.readVP("UniEvents");
    _newEvent = _oldEvent;
    _newEvent.volunteeeringOpportunity = _oldEvent.volunteeeringOpportunity;
  }

  //InputDecoration
  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  Container displayNumReg(
      bool enabled, BuildContext contx, uniEvent.Event event) {
    if (enabled) {
      return Container(
        child: TextFormField(
          initialValue: _oldEvent.noOfSeats.toString(),
          decoration: InputDecoration(
              labelText: 'number of registration seats',
              hintText: 'only if registration is enabled',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  borderSide: new BorderSide())),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: (input) {
            final isDigitsOnly = int.tryParse(input);

            return isDigitsOnly == null
                ? 'Input needs to be digits only'
                : null;
          },
          onSaved: (input) {
            event.noOfSeats = (int.parse(input));
          },
        ),
      );
    }
    return Container();
  }

  // date input
  Container displayDateInput(bool enabled) {
    if (enabled) {
      return Container(
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
              _newEvent.dates[0] = d;
            });
          },
        ),
      );
    }
    return Container();
  }

  // time input
  DateTimeField displayTimeInput(bool enabled) {
    // if (enabled) {
    return DateTimeField(
      enabled: (enabled) ? true : false,
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
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        _newEvent.time =
            intl.DateFormat.Hm().format(DateTimeField.convert(time)).toString();
        return DateTimeField.convert(time);
      },
    );
    //  }
    //return DateTimeField(enabled: false,);
  }

  void changedDropDownItem(value) {
    setState(() {
      this.department = value;
    });
  }

  Image displayImage(io.File image, uniEvent.Event event) {
    if (image == null)
      return Image.network(event.poster,
          height: 150, width: 150, fit: BoxFit.fill);
    else
      return Image.file(image);
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = io.File(pickedImage.path);
        _newEvent.poster = _imageURL;
      } else {
        print('No image selected.');
      }
    });
  }

  void _showDialog(BuildContext context) {
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('University Event Edited Successfully! ')));
  }

  @override
  Widget build(BuildContext context) {
    //_newEvent.leader = passedUser;

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
                Text('Edit University Event Form'),
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
                          // title input - done
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: TextFormField(
                              initialValue: _oldEvent.title,
                              decoration: _inputDecoration('Title'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Event title';
                                } else
                                  return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _newEvent.title = val),
                            ),
                          ),

                          // do you want to change the date?
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SwitchListTile(
                              title: Text("do you want to change the date ?",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              value: changeDate,
                              onChanged: (bool val) =>
                                  setState(() => changeDate = val),
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.green,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red,
                            ),
                          ),

                          // add new dates
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: displayDateInput(changeDate),
                          ),

                          // do you want to change the Time?
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SwitchListTile(
                              title: Text("do you want to change the Time ?",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              value: changeTime,
                              onChanged: (bool val) =>
                                  setState(() => changeTime = val),
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.green,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red,
                            ),
                          ),

                          // time input
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: displayTimeInput(changeTime),
                          ),

                          // location input - done
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: TextFormField(
                              initialValue: _oldEvent.place,
                              decoration: _inputDecoration('Location'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter event location';
                                } else
                                  return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _newEvent.place = val),
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
                                    child: displayImage(_image, _oldEvent),
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
                              initialValue: _oldEvent.description,
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
                                  setState(() => _newEvent.description = val),
                            ),
                          ),

                          // choose department
                          ListTile(
                            title: FittedBox(
                              child: Text(
                                "Choose a PSU \ndepartment: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: DropdownButton(
                              hint: Text(_oldEvent.department),
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
                                  _newEvent.department = newValue;
                                });
                              },
                            ),
                          ),

                          //enable registration
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SwitchListTile(
                              title: Text("Change Registration Status",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              value: changeRS, //changed from new to old !!
                              onChanged: (bool val) =>
                                  setState(() => changeRS = val),
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.green,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red,
                            ),
                          ),

                          // number of registration seats
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: displayNumReg(changeRS, context, _newEvent),
                          ),

                          // add volunteering positions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18.0),
                            child: FormField(
                              initialValue: false,
                              builder: (FormFieldState formFieldState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: volPos,
                                          onChanged: (value) {
                                            formFieldState.didChange(value);
                                            setState(() {
                                              volPos = value;
                                              _newEvent
                                                  .volunteeeringOpportunity[0]
                                                  .date = _newEvent.dates[0];
                                              _newEvent
                                                  .volunteeeringOpportunity[0]
                                                  .time = _newEvent.time;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Change volunteering positions.',
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
                                    if (volPos != false)
                                      Row(
                                        children: <Widget>[
                                          showText(),
                                          Expanded(
                                            child: TextFormField(
                                              initialValue: _oldEvent
                                                  .volunteeeringOpportunity[0]
                                                  .numberOfPositions
                                                  .toString(),
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
                                                    setState(() => _newEvent
                                                            .volunteeeringOpportunity[
                                                                0]
                                                            .numberOfPositions =
                                                        digitValue);
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
                                              initialValue: _oldEvent
                                                  .volunteeeringOpportunity[0]
                                                  .description
                                                  .toString(),
                                              decoration: _inputDecoration(
                                                  'Description'),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter event volunteering position';
                                                } else
                                                  return null;
                                              },
                                              onSaved: (val) => setState(() =>
                                                  _newEvent
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
                                  _newEvent.registrationStatus = changeRS;
                                  final form = _eventFormKey.currentState;
                                  if (form.validate()) {
                                    if (mounted) {
                                      setState(() {
                                        void _saveForm() async {
                                          form.save();
                                          if (_image != null) {
                                            final referenceTRG = FirebaseStorage
                                                .instance
                                                .ref()
                                                .child("images");
                                            await referenceTRG
                                                .child(_newEvent.title +
                                                    "_poster.jpg")
                                                .putFile(_image);
                                            final _url = await referenceTRG
                                                .child(_newEvent.title +
                                                    "_poster.jpg")
                                                .getDownloadURL();
                                            _imageURL = _url;
                                            _newEvent.poster = _imageURL;
                                          }

                                          _newEvent
                                              .saveUniEventsEdited(oldTitle);
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
