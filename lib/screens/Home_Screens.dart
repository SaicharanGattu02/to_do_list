import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../data/To_doData.dart';

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> with SingleTickerProviderStateMixin {
  final NotesController controller = Get.put(NotesController());
  late TabController _tabController;

  final List<String> items = ['Work', 'Personal', 'Shopping'];

  @override
  void initState() {
    super.initState();
    controller.loadNotes();
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(color: Color(0xff000000),fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: items.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: items.map((category) {
                return Obx(() {
                  final categoryNotes = controller.notes[category] ?? [];
                  return Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeleteAllNotesDialog(context, category);
                          },
                          child: Text('Delete All Notes',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600), ),
                        ),
                      ),
                     SizedBox(height: 20,),
                      Expanded(
                        child: ListView.builder(
                          itemCount: categoryNotes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  categoryNotes[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_note, color: Colors.grey),
                                      onPressed: () => _showEditNoteDialog(context, category, index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outlined, color: Colors.grey),
                                      onPressed: () {
                                        controller.deleteNoteFromCategory(category, index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                });
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        mini: true,
        hoverColor: Colors.grey,
        backgroundColor: Colors.yellow,
        onPressed: () {
          _showAddNoteBottomSheet(context);
        },
        child: Icon(
          Icons.add,
          size: 18,
        ),
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final TextEditingController _controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(height: h*0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Inter",
                          color: Color(0xffAFAFAF),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(value: item, child: Text(item)))
                      .toList(),
                  value: controller.selectedCategory.value,
                  onChanged: (value) {
                    setState(() {
                      controller.selectedCategory.value = value!;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: w,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Color(0xffD0CBDB)),
                      color: Color(0xffFCFAFF),
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, size: 25),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Add Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Title Field
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff8856F4),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  hintText: 'Enter your notes',
                  hintStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    letterSpacing: 0,
                    height: 19.36 / 14,
                    color: Color(0xffAFAFAF),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: const Color(0xffFCFAFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                    const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                    const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                    const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide:
                    const BorderSide(width: 1, color: Color(0xffd0cbdb)),
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
              SizedBox(height: 10),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.black,fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        controller.addNoteToCategory(
                          controller.selectedCategory.value,
                          _controller.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('ADD NOTES',style: TextStyle(color: Colors.black,fontSize: 16),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, String category, int index) {
    final TextEditingController _controller = TextEditingController(
      text: controller.notes[category]?[index],
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content:
        SizedBox(height:50,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.text,
            cursorColor: Color(0xff8856F4),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              hintText: 'Enter your notes',
              hintStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                letterSpacing: 0,
                height: 19.36 / 14,
                color: Color(0xffAFAFAF),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: const Color(0xffFCFAFF),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide:
                const BorderSide(width: 1, color: Color(0xffd0cbdb)),
              ),
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',style: TextStyle(color: Colors.black,fontSize: 16),),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                controller.editNoteInCategory(category, index, _controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('UPDATE',style: TextStyle(color: Colors.black,fontSize: 16),),
          ),
        ],
      ),
    );
  }
  void _showDeleteAllNotesDialog(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Notes'),
        content: const Text('Are you sure you want to delete all notes in this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteAllNotesFromCategory(category); // Deletes all notes
              Navigator.pop(context);
            },
            child: const Text('DELETE ALL', style: TextStyle(color: Colors.black, fontSize: 16)),

          ),
        ],
      ),
    );
  }

}
