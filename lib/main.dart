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
  void initState() {
    super.initState();
    _refreshJournals();
    print(".. number of items ${_journals.length}");
  }

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
  final TextEditingController _studentAddressController =
      TextEditingController();
  final TextEditingController _studentEnrollmentController =
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
      _studentNameController.text = existingJournal['name'];
      _studentAddressController.text = existingJournal['address'];
      _studentEnrollmentController.text = existingJournal['enrollment'];
    }
    setState(() {});
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _studentNameController.text,
        _studentAddressController.text, _studentEnrollmentController.text);
    _refreshJournals();
  }

  Future<void> _addItem() async {
    print("add item");
    await SQLHelper.createItem(_studentNameController.text,
        _studentAddressController.text, _studentEnrollmentController.text);
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
        title: Text((widget.id == null) ? "Add Student" : "Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(hintText: "Student Name"),
              ),
              TextFormField(
                controller: _studentEnrollmentController,
                decoration: const InputDecoration(hintText: "Roll No."),
              ),
              TextFormField(
                controller: _studentAddressController,
                decoration: const InputDecoration(hintText: "Address"),
              ),

              Container(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      if (widget.id == null) {
                        _addItem();
                      } else {
                        _updateItem(widget.id!);
                      }
                      // _submitForm(widget.id);
                      Navigator.pop(context);
                    },
                    child: const Text("Save Student Data")),
              ),
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
        title: Text("List of students"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _journals.length,
        itemBuilder: (context, index) {
          print("this is lengthhhhhhhhhhhhhhhhhhhhhhh");
          print(_journals.length);
          return Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: Text(_journals[index]['name'] ?? "no data"),
              subtitle: Row(
                children: [
                  Text(
                      "Roll No:${_journals[index]['enrollment']}" ?? "no data"),
                  Text("Add: ${_journals[index]['address']}" ?? "no data")
                ],
              ),
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
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
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
