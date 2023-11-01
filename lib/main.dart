import 'package:flutter/material.dart';
import 'package:program11/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final TextEditingController _studentNameController = TextEditingController();
  // final TextEditingController _studentDescriptionController =
  //     TextEditingController();

  // Future<void> _addItem() async {
  //   await SQLHelper.createItem(
  //       _studentNameController.text, _studentDescriptionController.text);
  //   _refreshJournals();
  // }

  // List<Map<String, dynamic>> _journals = [];
  // bool _isLoading = true;
  //
  // void _refreshJournals() async {
  //   final data = await SQLHelper.getItems();
  //   setState(() {
  //     _journals = data;
  //     _isLoading = false;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _refreshJournals();
  //   print(".. number of items ${_journals.length}");
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("program 9"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  // _addItem();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStudent(),
                      ));
                },
                child: const Text("Add Student")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowListOfStudent(),
                      ));
                },
                child: const Text("List Student Record")),
          ],
        ),
      ),
    );
  }
}

class AddStudent extends StatefulWidget {
  final int? id;

  const AddStudent({super.key, this.id});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _studentDescriptionController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("idddddddddddddddddddd ${widget.id}");
    _refreshJournals();

    Future.delayed(
      const Duration(milliseconds: 500),
      () => _chechForEdit(widget.id),
    );
    // _chechForEdit(widget.id);
  }

  void _chechForEdit(int? id) async {
    print("check of iddddddd ${id}");
    print("idddddddddddddd: ${_journals}");

    if (id != null) {
      final existingJournal =
          await _journals.firstWhere((element) => element['id'] == id);
      print("heeeeellllllo");
      _studentNameController.text = existingJournal['title'];
      _studentDescriptionController.text = existingJournal['description'];
    }
    setState(() {});
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _studentNameController.text, _studentDescriptionController.text);
    _refreshJournals();
  }

  Future<void> _addItem() async {
    print("add item");
    await SQLHelper.createItem(
        _studentNameController.text, _studentDescriptionController.text);
    print("after add item");
    _refreshJournals();
    print("numberrrrr of itemss : ${_journals.length}");
  }

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD Student"),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: _studentNameController,
              decoration: const InputDecoration(hintText: "student name"),
            ),
            TextFormField(
              controller: _studentDescriptionController,
              decoration: const InputDecoration(hintText: "student name"),
            ),
            ElevatedButton(
                onPressed: () {
                  if (widget.id == null) {
                    _addItem();
                  } else {
                    _updateItem(widget.id!);
                  }
                  // _submitForm(widget.id);
                  Navigator.pop(context);
                },
                child: const Text("Save")),
            // ElevatedButton(
            //     onPressed: () {
            //       // _submitForm(widget.id);
            //       // Navigator.pop(context);
            //       _chechForEdit(widget.id);
            //     },
            //     child: const Text("show")),
          ],
        ),
      ),
    );
  }
}

class ShowListOfStudent extends StatefulWidget {
  const ShowListOfStudent({super.key});

  @override
  State<ShowListOfStudent> createState() => _ShowListOfStudentState();
}

class _ShowListOfStudentState extends State<ShowListOfStudent> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("deleted successfully")));
    _refreshJournals();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
    print(".. number offffff items ${_journals.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of student"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _journals.length,
        itemBuilder: (context, index) {
          print("this is lengthhhhhhhhhhhhhhhhhhhhhhh");
          print(_journals.length);
          return Card(
            child: ListTile(
              title: Text(_journals[index]['title'] ?? "no data"),
              subtitle: Text(_journals[index]['description'] ?? "no data"),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddStudent(id: _journals[index]['id']),
                              ));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _deleteItem(_journals[index]['id']);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
              // title: Text("hello"),
            ),
          );
        },
      ),
    );
  }
}
