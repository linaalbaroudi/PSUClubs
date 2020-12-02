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

class EditClubWorkshop extends StatelessWidget {
  static const routeName = '/EditClubWorkshop';
  EditClubWorkshop({this.exampleClub, this.user, this.passedWorkshop});
  final Club exampleClub;
  final Faculty user;
  final Workshop passedWorkshop;

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
                Text('Edit Club Workshop Form'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddWorkshopView(
                  exampleClub: this.exampleClub, user: this.user, passedWorkshop: this.passedWorkshop),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class AddWorkshopView extends StatefulWidget {
  AddWorkshopView({this.exampleClub, this.user, this.app, this.passedWorkshop});
  final FirebaseApp app;
  final Club exampleClub;
  final Faculty user;
  final Workshop passedWorkshop;
  @override
  _AddWorkshopViewState createState() => _AddWorkshopViewState();
}

class _AddWorkshopViewState extends State<AddWorkshopView> {
  // passed data
  Club passedClub;
  Faculty passedUser;

  // workshop object to be submitted
  Workshop _oldWorkshop;
  Workshop _newWorkshop;// = new Workshop( null, "", "", "", null, "", "", 0, null);

  // form key
  final _workshopFormKey = GlobalKey<FormState>();

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
  //manage date and time input - done
  DateTime pickedDate = DateTime.now();
  DateTime pickedTime = DateTime.now();
  final format = intl.DateFormat("HH:mm");
  int dates = 1;
  bool changeDate = false;
  bool changeTime = false;
  bool firstTime=false;

  // manage image input
  io.File _image;
  String _imageURL;
 String oldTitle;
  //adding volunteering positions to the workshop
  bool volPos = false;
  List<String> theseDates;
  List<VolunteeringPosition> theseVP;

  void initState() {
    super.initState();
    getArgs(widget.exampleClub, widget.user, widget.passedWorkshop);
  }
  Text showText(int i){
    if (changeDate && changeTime)
      return  Text(
        'Date: ' +
            theseDates[i] +
            '\nTime: ' +
            _newWorkshop.time,
      );
    else if (changeDate)
      return  Text(
        'Date: ' +
            theseDates[i] +
            '\nTime: ' +
            _oldWorkshop.time,
      );
    else if (changeTime)
      return  Text(
        'Date: ' +
            _oldWorkshop.dates[i] +
            '\nTime: ' +
            _newWorkshop.time,
      );
    else
      return Text(
        'Date: ' +
            _oldWorkshop.dates[i] +
            '\nTime: ' +
            _oldWorkshop.time,
      );

  }

//done
  void getArgs(Club att1, Faculty att2, Workshop workshop) {
    passedUser = att2;
    passedClub = att1;
    _oldWorkshop =workshop;
    _newWorkshop = workshop;
    _oldWorkshop.dates=workshop.dates;
    _newWorkshop.dates=workshop.dates;
    oldTitle=_oldWorkshop.title;
    _oldWorkshop.readVP("ClubWorkshops");
    _newWorkshop.volunteeeringOpportunity=_oldWorkshop.volunteeeringOpportunity;
    theseDates=_oldWorkshop.dates;
    theseVP=_oldWorkshop.volunteeeringOpportunity;
    dates=_oldWorkshop.dates.length;
  }

//InputDecoration - done
  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));


//done
  Future getImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = io.File(pickedImage.path);
        _newWorkshop.poster = _imageURL;
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
        .showSnackBar(SnackBar(content: Text('Workshop Edited Successfully')));
  }

//new
  Row displayVP(int i, String time, Workshop _workshop, int currentDates) {
    if (changeTime){
      theseVP[i].time=_newWorkshop.time;
    }
    if (theseDates==null)
      return Row();
    return Row(
      children: <Widget>[
        showText(i),
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
                      theseVP[i].numberOfPositions=digitValue;

                    });
                    return null;
                  }    }}
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: TextFormField(
              decoration: _AddWorkshopViewState()._inputDecoration('Description'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter workshop volunteering position';
                } else
                  return null;
              },
              onSaved: (val) {
                theseVP[i].description = val;
              }
          ),)
      ],
    );
  }
  Container displayNumReg( BuildContext contx) {
    return Container(
        child: TextFormField(
          initialValue: _oldWorkshop.noOfSeats.toString(),
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
            _newWorkshop.noOfSeats = (int.parse(input));
          },
        ),
      );
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
        setState((){
          _newWorkshop.time =
              intl.DateFormat.Hm().format(DateTimeField.convert(time)).toString();
        });

        return DateTimeField.convert(time);
      },
    );
    //  }
    //return DateTimeField(enabled: false,);
  }
  Image displayImage(io.File image, Workshop workshop) {
    if (image == null)
      return Image.network(workshop.poster,
          height: 150, width: 150, fit: BoxFit.fill);
    else
      return Image.file(image);
  }
  // done
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
                theseDates[i]=d;
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
  Widget build(BuildContext context) {
    // if (_newWorkshop.dates.length>0&& firstTime==false){
    //   _newWorkshop.dates.clear();
    //   _newWorkshop.volunteeeringOpportunity.clear();
    //   firstTime=true;
    // }
    // _workshop.leader = passedUser;
    // _workshop.hostingClub = passedClub;

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
                    initialValue: _oldWorkshop.title,
                    decoration: _inputDecoration('Title'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter workshop title';
                      } else
                        return null;
                    },
                    onSaved: (val) => setState(() => _newWorkshop.title = val),
                  ),
                ),
                // do you want to change the date?
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SwitchListTile(
                    title: Text("do you want to change the dates ?",
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
                //number of dates
                changeDate?Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: TextFormField(
                    initialValue: _oldWorkshop.dates.length.toString(),// my submit the value as string not int
                    onChanged: (value) {
                      setState(() {
                        dates = int.parse(value);
                        theseDates = new List(dates);
                        theseVP= new List(dates);
                        _newWorkshop.dates = new List<String>();
                        _newWorkshop.volunteeeringOpportunity=new List<VolunteeringPosition>();
                        volPos=false;
                      });
                    },
                    decoration: InputDecoration(
                        labelText:
                        'How many days the workshop will take? Enter their dates',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            borderSide: new BorderSide())),
                    keyboardType: TextInputType.number,
                  ),
                ):SizedBox(),


                // date and time input - to check
                changeDate?Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 18.0),
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < dates; i++)
                        displayDatePickers(i, pickedDate, _newWorkshop),
                    ],
                  ),
                ):SizedBox(),

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
                //time input - to check
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
                    initialValue: _oldWorkshop.place,
                    decoration: _inputDecoration('Location'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter event location';
                      } else
                        return null;
                    },
                    onSaved: (val) =>
                        setState(() => _newWorkshop.place = val),
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
                          child: displayImage(_image, _oldWorkshop),
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
                    initialValue: _oldWorkshop.description,
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
                        setState(() => _newWorkshop.description = val),
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
                    hint: Text(_oldWorkshop.department),
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
                        _newWorkshop.department = newValue;
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                // number of registrants - done
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: displayNumReg(context),
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
                                  // When the value of the checkbox changes, update the FormFieldState so the form is re-validated.
                                  formFieldState.didChange(value);
                                  setState(() {
                                    volPos = value;
                                    if (changeDate){
                                      for (int i =0;i<dates;i++){
                                        theseVP[i]=new VolunteeringPosition("VP$i", _newWorkshop.time, theseDates[i], "", 0);
                                      }
                                    }
                                    else{
                                      theseVP = _oldWorkshop.volunteeeringOpportunity;
                                    }
                                  });
                                },
                              ),
                              Text(
                                'Change volunteering positions.',
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
                      if (volPos != false)
                        for (int i = 0; i < dates; i++)
                          displayVP(i, _newWorkshop.time, _newWorkshop,dates),
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
                        if (form.validate()) {
                          if (mounted) {
                            setState(() {
                              void _savaForm() async {
                                form.save();
                                if(_image!=null){
                                  final referenceTRG = FirebaseStorage.instance
                                      .ref()
                                      .child("images");
                                  await referenceTRG
                                      .child(_newWorkshop.title + "_poster.jpg")
                                      .putFile(_image);
                                  final _url =
                                  await referenceTRG.child(_newWorkshop.title + "_poster.jpg").getDownloadURL();
                                  _imageURL = _url;
                                  _newWorkshop.poster = _imageURL;
                                }
                                _newWorkshop.saveEditedWorkshop(oldTitle,theseDates,theseVP);
                                _showDialog(context);
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
