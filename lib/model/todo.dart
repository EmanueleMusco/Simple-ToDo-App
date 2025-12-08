class Todo {
  String testo;
  bool completato;

  Todo({required this.testo, this.completato = false});

  // CONVERSIONE PER SALVARE
  Map<String, dynamic> toJson() {
    return {
      'testo': testo,
      'completato': completato,
    };
  }

  // CONVERSIONE PER CARICARE 
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      testo: json['testo'],
      completato: json['completato'],
    );
  }
}