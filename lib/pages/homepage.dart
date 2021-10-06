import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/google_sign_in.dart';
import 'package:flutter_application_7/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? taskStream;

  DatabaseServices databaseServices = new DatabaseServices();
  TextEditingController taskEdittingControler1 = new TextEditingController();
  TextEditingController taskEdittingControler2 = new TextEditingController();
  TextEditingController taskEdittingControler3 = new TextEditingController();

  get doc => null;
  @override
  void initState() {
    databaseServices.getTasks().then((val) {
      taskStream = val;
      setState(() {});
    });

    super.initState();
  }

  Widget fetchData(String collectionName) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something is wrong"),
          );
        }
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                    itemCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      DocumentSnapshot _documentSnapshot =
                          snapshot.data!.docs[index];
                      return Card(
                        child: Container(
                          child: Container(
                              child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> taskMap = {
                                      "isWatched":
                                          !_documentSnapshot['isWatched']
                                    };
                                    DatabaseServices().updateTask(
                                      taskMap,
                                      (snapshot.data! as QuerySnapshot)
                                          .docs[index]
                                          .id,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black,
                                            width: 1), // Mark Todo as Updated
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: _documentSnapshot['isWatched']
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Container(),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Column(children: [
                                Text(
                                  _documentSnapshot['Name'],
                                  style: TextStyle(fontSize: 20),
                                ),
                                Image.asset(
                                  _documentSnapshot['Image'],
                                  width: 200,
                                ),
                                Text(
                                  _documentSnapshot['Director'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ]),
                              SizedBox(
                                width: 50,
                              ),
                              GestureDetector(
                                onTap: () {
                                  DatabaseServices().deleteTask(
                                      _documentSnapshot[
                                          (snapshot.data! as QuerySnapshot)
                                              .docs[index]
                                              .id]);
                                },
                                child: Icon(Icons.close,
                                    size: 30,
                                    color: Colors.black), // Delete Todo
                              )
                            ],
                          )),
                        ),
                      );
                    }),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            }),
        title: Text("Todo App"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: taskEdittingControler1,
                    decoration: InputDecoration(hintText: "Name"),
                    onChanged: (text) {
                      taskEdittingControler1.text = text;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                taskEdittingControler1.text.isNotEmpty &&
                        taskEdittingControler2.text.isNotEmpty &&
                        taskEdittingControler3.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          Map<String, dynamic> taskMap = {
                            "Name": taskEdittingControler1.text,
                            "Director": taskEdittingControler2.text,
                            "Image": taskEdittingControler3.text,
                            "isWatched": true
                          };
                          databaseServices.createTask(taskMap);
                          taskEdittingControler1.text = "";
                          taskEdittingControler2.text = "";
                          taskEdittingControler3.text = "";
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(color: Colors.blue)))
                    : Container()
              ]),
              Row(children: [
                Expanded(
                  child: (TextField(
                      controller: taskEdittingControler2,
                      decoration: InputDecoration(hintText: "Director"),
                      onChanged: (text) {
                        taskEdittingControler2.text = text;
                        setState(() {});
                      })),
                ),
              ]),
              Row(children: [
                Expanded(
                  child: (TextField(
                      controller: taskEdittingControler3,
                      decoration: InputDecoration(hintText: "Image"),
                      onChanged: (text) {
                        taskEdittingControler3.text = text;
                        setState(() {});
                      })),
                ),
              ]),
              fetchData("movies")
            ],
          ),
        ),
      ),
    );
  }
}
