import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/Certificate.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class CertificateView extends StatelessWidget {
  static const routeName = '/CertificateView';
  CertificateView({this.user, this.app});
  final FirebaseApp app;
  final Student user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: PreferredSize(
            preferredSize:  Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: Color(0xff1A033D),
              title: Text(' Certificates'),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CertificatesPage(
                  user: this.user,
                  app: this.app,
                ),
              ),
            ),
          ),
          endDrawer: StudentDrawer(user: this.user)),
    );
  }
}

class CertificatesPage extends StatefulWidget {
  CertificatesPage({this.user, this.app});
  final Student user;
  final FirebaseApp app;
  @override
  _CertificatesPageState createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  Student passedStudent;
  List<Certificates> earnedCerts = new List<Certificates>();
  bool _permissionReady;
  String _localPath;
  bool _isLoading;
  List colors = [
    Color.fromARGB(200, 2, 162, 173),
    Color.fromARGB(200, 5, 145, 151),
    Color.fromARGB(200, 161, 191, 52),
    Color.fromARGB(200, 242, 116, 5),
    Color.fromARGB(200, 242, 116, 5)
  ];
  Random random = new Random();

  Padding displayCertificates(int certNum, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.asset(
              'assets/images/certificate.png',
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Color.fromARGB(200, 2, 162, 173),
                color: colors[random.nextInt(4 - 0) + 0],
              ),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      earnedCerts[certNum].title+
                          '\n' +
                          earnedCerts[certNum].date,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlatButton(
                    color: Colors.black,
                    onPressed: () async{
                      final status = await Permission.storage.request();
                      if(status.isGranted){
                        final externalDir =await getExternalStorageDirectory();



                        FlutterDownloader.enqueue(
                              url:  earnedCerts[certNum].getURL,
                               savedDir:externalDir.path,
                              fileName:earnedCerts[certNum].title,
                              showNotification:true,
                              openFileFromNotification: true,
                            );
                      }

                    },
                    child: Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  void initState() {
    super.initState();
    getArgs(widget.user);
  }

  void getArgs(Student att2) {
    passedStudent = att2;
    readData();
  }

  void readData() async {
    final referenceDb =
    FirebaseDatabase.instance.reference().child("Certificates");
    await referenceDb.once().then((DataSnapshot dataSnapshot) {
      earnedCerts.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
     for (var key in keys) {
        if (key.toString().contains(this.passedStudent.userID)) {
          Certificates certificate = new Certificates(
              values[key]["generator"],
              values[key]["pdf"],
              values[key]["studentID"],
              values[key]["date"],
              values[key]["title"]);
          if (mounted) {
            setState(() {
              print(certificate);
              earnedCerts.add(certificate);
            });
          }
        }
      }
    });
  }
bool entered = false;
  @override
  Widget build(BuildContext context) {
    if (!entered){
      entered = true;
      readData();
    }

    return Container(
      child: Column(
        children: <Widget>[
          for (int i = 0; i < earnedCerts.length; i++)
            displayCertificates(i, context),
          if(earnedCerts.length==0)Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:<Widget>[
                Image.asset(
                    'assets/images/NoAddedActivities.gif',
                    height: 350,
                    width:350,
                    fit: BoxFit.fill
                ),
                Text(
                  "Excuse me what were you looking for?\nI live here",
                  style:TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
