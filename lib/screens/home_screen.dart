import 'dart:io';
import 'dart:math';
import 'package:demo/constants/env.dart';
import 'package:demo/models/user_model.dart';
import 'package:demo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_model.dart';
import '../repository/auth_repo.dart';
import '../repository/notes_repo.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userData;
  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotesRepo _notesRepo;
  late final AuthRepo _authRepo;
  late final ImagePicker _imagePicker;
  final String bucketName = "srikanta";
  final String dummyImageUrl = "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg";
  late final StorageFileApi bucket;
  final Set<String> idsToDelete = {};
  Map<String,bool> selectedDeleteIds = {};
  late UserModel userData;

  @override
  void initState() {
    super.initState();
    bucket = Supabase.instance.client.storage.from(bucketName);
    _authRepo = AuthRepo();
    _notesRepo = NotesRepo();
    userData = widget.userData;
    _imagePicker = ImagePicker();
  }


  
  void _noteDialog(BuildContext context, {String type = "Add", NoteModel? noteModel}) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    titleController.text = noteModel?.title??"";
    contentController.text = noteModel?.content??"";
    bool isPinned = noteModel?.isPinned??false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: type=="Add"?const Text('Add Note'):const Text('Edit Note'),
              content: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pin this note'),
                      Switch(
                        value: isPinned,
                        onChanged: (value) {
                          setState(() {
                            isPinned = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Cancel
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();
                    if (title.isEmpty || content.isEmpty) return;
                    if(type=="Add") {
                      await _notesRepo.addNote(
                        title: title,
                        content: content,
                        createdAt: DateTime.now(),
                        lastModifiedAt: DateTime.now(),
                        isPinned: isPinned,
                        userId: widget.userData.id
                      );
                    }else if(noteModel!=null){
                      await _notesRepo.updateNote(
                        noteModel,
                        title: title,
                        content: content,
                        isPinned: isPinned,
                      );
                    }
                    Navigator.pop(context); // Close dialog
                  },
                  child: type=="Add"?const Text('Add'):const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addOrDeleteId(bool? checked, String id){
    if(checked==true){
      idsToDelete.add(id);
    }else{
      idsToDelete.remove(id);
    }
    setState(()=>selectedDeleteIds[id] = checked??false);
  }

  void onDeleteClick()async{
    for(var id in idsToDelete){
      await _notesRepo.deleteNote(id);
    }
    setState(()=>idsToDelete.clear());
  }

  void showImageAccessDialog(){
    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please select image"),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                    uploadProfileImage(ImageSource.camera);
                  }, child: Text("Camera")),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                    uploadProfileImage(ImageSource.gallery);
                  }, child: Text("Gallery"))
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> uploadProfileImage(ImageSource imageSource)async{
    final pickedFile = await _imagePicker.pickImage(source: imageSource);
    if(pickedFile==null) {
      showSnackBar(context, "No image selected");
      return;
    }
    File file = File(pickedFile.path);
    final path = await bucket.upload("uploads/${pickedFile.name}", file);
    print("path $path");
    final url = "${Env.supabaseUrl}/storage/v1/object/public/$path";
    _authRepo.updateImage(url);
    setState(()=>userData = userData.copyWith(profileImage: url));
  }



  // Future<void> uploadProfileImage()async{
  //   ImagePicker imagePicker = ImagePicker();
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if(pickedFile==null) return;
  //   final File file = File(pickedFile.path);
  //   final storage = Supabase.instance.client.storage;
  //   final bucket = storage.from(bucketName);
  //   final path = await bucket.upload("uploads/${pickedFile.name}", file);
  //   final url = "${Env.supabaseUrl}/storage/v1/object/public/$path";
  //   await _authRepo.updateImage(url);
  //   userData = userData.copyWith(profileImage: url);
  //   setState(()=>userData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteStack'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        leading: GestureDetector(
          onTap: showImageAccessDialog,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                userData.profileImageUrl??dummyImageUrl,
                errorBuilder: (context, _,__){
                  return const Icon(Icons.person);
                },
            )),
          ),
        ),
        actions: [
          Visibility(
              visible: idsToDelete.isNotEmpty,
              child: IconButton(onPressed: onDeleteClick, icon:Icon(Icons.delete)))
        ],
      ),
        body: StreamBuilder<List<NoteModel>>(
          stream: _notesRepo.getNotes(widget.userData.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text("No notes yet"));
            }

            final notes = snapshot.data!;
            for (var note in notes) {
              selectedDeleteIds[note.id] = selectedDeleteIds[note.id]??false;
            }
            notes.sort((a,b){
              if(a.isPinned&&b.isPinned) return 0;
              if(a.isPinned) return -1;
              if(b.isPinned) return 1;
              return 0;
            });
            return ListView.builder(
              key: ObjectKey(notes),
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  key: ValueKey(note.id),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onLongPress: ()=>_noteDialog(context, type: "Edit", noteModel: note),
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Checkbox(value: selectedDeleteIds[note.id], 
                        onChanged:(checked)=>addOrDeleteId(checked, note.id)),
                    trailing: note.isPinned
                        ? const Icon(Icons.push_pin, color: Colors.green)
                        : null,
                  ),
                );
              },
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _noteDialog(context),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
