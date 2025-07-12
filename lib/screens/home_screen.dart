import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../repository/notes_repo.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotesRepo _notesRepo = NotesRepo();
  Map<String,bool> selectedDeleteIds = {};
  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isPinned = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Note'),
              content: Column(
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

                    if (title.isNotEmpty || content.isNotEmpty) {
                      await _notesRepo.addNote(
                        title: title,
                        content: content,
                        createdAt: DateTime.now(),
                        lastModifiedAt: DateTime.now(),
                        isPinned: isPinned,
                      );
                    }

                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteStack'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
        body: StreamBuilder<List<NoteModel>>(
          stream: _notesRepo.getNotes(),
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
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Checkbox(value: selectedDeleteIds[notes[index].id], onChanged: (value){
                      setState(()=>selectedDeleteIds[notes[index].id] = value!);
                    }),
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
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
