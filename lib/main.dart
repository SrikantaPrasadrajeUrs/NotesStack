import 'package:demo/firebase_options.dart';
import 'package:demo/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  void add(){
    controller.clear();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: TextField(
          controller: controller,
        ),
      );
    }).whenComplete((){
      FirestoreService().add(controller.text);
    });
  }

  void update(String id) {
    controller.clear();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: TextField(
          controller: controller,
        ),
      );
    }).whenComplete((){
      FirestoreService().updateNote(id,controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Firebase"),
        actions:[
          IconButton(onPressed: add, icon:Icon(Icons.add))
        ]
      ),
      body: StreamBuilder(
          stream: FirestoreService().getNotes(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      onLongPress: ()=>update(snapshot.data![index]['id']),
                      onTap: ()=>FirestoreService().delete(snapshot.data![index]['id']),
                      title: Text(snapshot.data![index]['note']),
                    );
                  });
            }else{
              return SizedBox();
            }
          }),
    );
  }
}
