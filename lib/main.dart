import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.orange),
      home: MyApp(),
    )); //Mater*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.orange),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String todoTitle = "";
  // List todos = List();
  //String input = "";
  final texteditingcontroller = TextEditingController();
//  String errtext = "";
  bool validated = true;

  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);

    //Map
    Map<String, String> todos = {"todoTitle": todoTitle};
    documentReference.set(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  void initState() {
    super.initState();
    /*  todos.add("item1");	
  /*  todos.add("item2");*/
    todos.add("item3");
    todos.add("item4");*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Todos"),
      ), //appbar

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          texteditingcontroller.clear();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todolist"),
                  content: TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (String value) {
                      todoTitle = value;
                    },
                  ), //textfiedl

                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            if (texteditingcontroller.text.isEmpty) {
                              setState(() {
                                // input = "";
                                todoTitle = "";
                                validated = false;
                              });
                            } else
                              /* todos.add(input);*/
                              createTodos();
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Add")) //flat
                  ],
                ); //Alert
              });
        },
        child: Icon(Icons.add, color: Colors.white), //icon
      ),

      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return CircularProgressIndicator();
            //-   var snapshots;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data.documents[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        deleteTodos(documentSnapshot.data()["todoTitle"]);
                      },
                      key: Key(documentSnapshot.data()["todoTitle"]),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(documentSnapshot.data()['todoTitle']),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteTodos(
                                    documentSnapshot.data()["todoTitle"]);
                              }),
                        ), //iconbutton
                      )); // listtile
                  //card// dissem
                }); //listview
          }),
    ); // SCAFF
  }
}
