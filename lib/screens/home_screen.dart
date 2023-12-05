import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/screens/note_editor.dart';
import 'package:flutter_note_app/screens/note_reader.dart';
import 'package:flutter_note_app/style/app_style.dart';
import 'package:flutter_note_app/widgets/note_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        elevation: 0.0,
        title: const Text("Notas", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tus notas recientes", style: GoogleFonts.roboto(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 22.0)),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  if(snapshot.hasData){
                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: snapshot.data!.docs.map((note) => noteCard((){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NoteReaderScreen(note)));
                      }, note)).toList(),
                    );
                  }
            
                  return Text("No hay notas", style: GoogleFonts.nunito(color: Colors.white));
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteEditorScreen()));
        }, 
        backgroundColor: Colors.purple.shade300,
        label: const Text("Añadir la nota", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}