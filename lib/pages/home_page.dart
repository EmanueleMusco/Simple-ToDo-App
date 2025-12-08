import 'package:flutter/material.dart';
import 'package:todo_semplice/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = []; // lista dei todo
  TextEditingController controller = TextEditingController();

  @override
void initState() {
  super.initState();
  caricaDati();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Todo Semplice',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[400],
      ),

      backgroundColor: Colors.blue[100],

      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return buildTodoItem(todos[index], index);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: aggiungiTodo,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }


  // COSTRUZIONE DI OGNI TODO

  Widget buildTodoItem(Todo todo, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Checkbox(
            value: todo.completato,
            onChanged: (val) {
              setState(() {
                todo.completato = val!;
              });
              salvaDati(); //salva quando si spunta il checkbox
            },
          ),
      
          Expanded(
            child: GestureDetector(
              onTap: () => modificaTodo(todo, index),
              child: Text(
                todo.testo,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  decoration: todo.completato
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
      
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                todos.removeAt(index);
              });
              salvaDati();
            },
          )
        ],
      ),
    );
  }


  // MODIFICA TODO

  void modificaTodo(Todo todo, int index) {
    TextEditingController editController =
        TextEditingController(text: todo.testo);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Modifica ToDo"),
          content: TextField(
            controller: editController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todo.testo = editController.text;
                });
                salvaDati();
                Navigator.pop(context);
              },
              child: Text("Salva"),
            ),
          ],
        );
      },
    );
  }


  // AGGIUNGI TODO

  void aggiungiTodo() {
    controller.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Nuovo ToDo"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: "Scrivi il ToDo"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    todos.add(Todo(testo: controller.text.trim()));
                  });
                  salvaDati();
                }
                Navigator.pop(context);
              },
              child: Text("Aggiungi"),
            ),
          ],
        );
      },
    );
  }


  //SALVATAGGIO DEI DATI

  void salvaDati() async {
  final prefs = await SharedPreferences.getInstance();

  List<Map<String, dynamic>> jsonList =
      todos.map((todo) => todo.toJson()).toList();

  prefs.setString("todos", jsonEncode(jsonList));
}

//CARICAMENTO DEI DATI

void caricaDati() async {
  final prefs = await SharedPreferences.getInstance();

  String? data = prefs.getString("todos");

  if (data != null) {
    List decoded = jsonDecode(data);

    setState(() {
      todos = decoded.map((e) => Todo.fromJson(e)).toList();
    });
  }
}



}
