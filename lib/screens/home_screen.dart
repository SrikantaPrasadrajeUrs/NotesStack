import 'dart:io';
import 'package:NotesStack/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/env.dart';
import '../core/services/secure_storage_service.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';
import '../repository/auth_repo.dart';
import '../repository/notes_repo.dart';
import '../utils/utils.dart';

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
  final String storageBucketName = "profileImages";
  final String dummyImageUrl =
      "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg";
  late final StorageFileApi bucket;
  final Set<String> idsToDelete = {};
  Map<String, bool> selectedDeleteIds = {};
  late UserModel userData;

  @override
  void initState() {
    super.initState();
    bucket = Supabase.instance.client.storage.from(storageBucketName);
    _authRepo = AuthRepo();
    _notesRepo = NotesRepo();
    userData = widget.userData;
    _imagePicker = ImagePicker();
  }

  void _noteDialog(
    BuildContext context, {
    String type = "Add",
    NoteModel? noteModel,
  }) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    titleController.text = noteModel?.title ?? "";
    contentController.text = noteModel?.content ?? "";
    bool isPinned = noteModel?.isPinned ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.yellow.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type == "Add" ? "Add Note" : "Edit Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.yellow.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.yellow.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.yellow.shade600,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.yellow.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.yellow.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.yellow.shade600,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pin this note',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: isPinned,
                          activeColor: Colors.yellow.shade700,
                          onChanged: (value) {
                            setState(() {
                              isPinned = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            elevation: 3,
                          ),
                          onPressed: () async {
                            final title = titleController.text.trim();
                            final content = contentController.text.trim();
                            if (title.isEmpty || content.isEmpty) return;
                            if (type == "Add") {
                              await _notesRepo.addNote(
                                title: title,
                                content: content,
                                createdAt: DateTime.now(),
                                lastModifiedAt: DateTime.now(),
                                isPinned: isPinned,
                                userId: widget.userData.id,
                              );
                            } else if (noteModel != null) {
                              await _notesRepo.updateNote(
                                noteModel,
                                title: title,
                                content: content,
                                isPinned: isPinned,
                              );
                            }
                            Navigator.pop(context); // Close dialog
                          },
                          child: Text(
                            type == "Add" ? "Add" : "Update",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addOrDeleteId(bool? checked, String id) {
    if (checked == true) {
      idsToDelete.add(id);
    } else {
      idsToDelete.remove(id);
    }
    setState(() => selectedDeleteIds[id] = checked ?? false);
  }

  void onDeleteClick() async {
    for (var id in idsToDelete) {
      await _notesRepo.deleteNote(id);
    }
    setState(() => idsToDelete.clear());
  }

  void showImageAccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: 160,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border(
                top: BorderSide(
                  color: Color.fromRGBO(239, 191, 4, 1),
                  width: 3,
                ),
                left: BorderSide(color: Color.fromRGBO(239, 191, 4, 1)),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white70,
                  Colors.yellow.shade100,
                  Colors.yellow.shade200,
                  Colors.yellow.shade300,
                  Colors.yellow.shade400,
                  Colors.yellow.shade500,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.15),
                  blurRadius: 20,
                  offset: const Offset(5, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔹 Actual content
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Select image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            uploadProfileImage(ImageSource.gallery);
                          },
                          child: Image.asset(
                            "assets/images/apple_gallery.png",
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            uploadProfileImage(ImageSource.camera);
                          },
                          child: Image.asset(
                            "assets/images/camera.png",
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadProfileImage(ImageSource imageSource) async {
    final pickedFile = await _imagePicker.pickImage(source: imageSource);
    if (pickedFile == null) {
      showSnackBar(context, "No image selected");
      return;
    }
    final File file = File(pickedFile.path);
    final storage = Supabase.instance.client.storage;
    final bucket = storage.from(storageBucketName);
    final path = await bucket.upload(
      "${userData.id}-${pickedFile.name}",
      file,
      fileOptions: FileOptions(upsert: true),
    );
    final url = "${Env.supabaseUrl}/storage/v1/object/public/$path";
    Future.wait([
      _authRepo.updateImage(uid: userData.id,imageUrl:url),
    ]);
    userData = userData.copyWith(profileImage: url);
    setState(() => userData);
  }

  void logout() async {
    await _authRepo.logout().then((_) async {
      await SecureStorageService().clearStorage();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(authRepo: _authRepo),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      drawer: Drawer(
        backgroundColor: Colors.yellow.shade50,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              GestureDetector(
                onTap: showImageAccessDialog,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha:0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      userData.profileImageUrl ?? dummyImageUrl,
                      errorBuilder: (context, _, __) {
                        return const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        );
                      },
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userData.name ?? "User",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                userData.email ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown.shade600,
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(14),
                    elevation: 3,
                  ),
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Sign out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'NoteStack',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.yellow.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: showImageAccessDialog,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                userData.profileImageUrl ?? dummyImageUrl,
                errorBuilder: (context, _, __) {
                  return const Icon(Icons.person, color: Colors.white);
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: [
          Visibility(
            visible: idsToDelete.isNotEmpty,
            child: IconButton(
              onPressed: onDeleteClick,
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ),
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
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No notes yet",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final notes = snapshot.data!;
          for (var note in notes) {
            selectedDeleteIds[note.id] = selectedDeleteIds[note.id] ?? false;
          }
          notes.sort((a, b) {
            if (a.isPinned && b.isPinned) return 0;
            if (a.isPinned) return -1;
            if (b.isPinned) return 1;
            return 0;
          });

          return ListView.builder(
            key: ObjectKey(notes),
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                key: ValueKey(note.id),
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shadowColor: Colors.yellow.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onLongPress:
                      () => _noteDialog(context, type: "Edit", noteModel: note),
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  leading: Checkbox(
                    activeColor: Colors.yellow.shade600,
                    value: selectedDeleteIds[note.id],
                    onChanged: (checked) => addOrDeleteId(checked, note.id),
                  ),
                  trailing:
                      note.isPinned
                          ? Icon(Icons.push_pin, color: Colors.yellow.shade700)
                          : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _noteDialog(context),
        backgroundColor: Colors.yellow.shade700,
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
