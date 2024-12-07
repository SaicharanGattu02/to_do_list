import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController extends GetxController {
  var notes = <String, List<String>>{}.obs;
  var selectedCategory = 'Work'.obs;

  void loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedNotes = prefs.getString('notes');
    if (storedNotes != null) {
      notes.value = Map<String, List<String>>.from(
        json.decode(storedNotes),
      );
    }
  }

  void saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', json.encode(notes));
  }

  void addNoteToCategory(String category, String note) {
    if (!notes.containsKey(category)) {
      notes[category] = [];
    }
    notes[category]!.add(note);
    notes.refresh();
    saveNotes();
  }

  void editNoteInCategory(String category, int index, String newNote) {
    notes[category]?[index] = newNote;
    notes.refresh();
    saveNotes();
  }

  void deleteNoteFromCategory(String category, int index) {
    notes[category]?.removeAt(index);
    notes.refresh();
    saveNotes();
  }

  void deleteAllNotesFromCategory(String category) {
    notes[category]?.clear();
    notes.refresh();
    saveNotes();
  }
}
