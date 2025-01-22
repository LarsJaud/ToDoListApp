//
//  ToDoDetailView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//
import SwiftUI

struct ToDoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var todos: [ToDo]
    @Binding var initialTitle: String
    @Binding var editingToDo: ToDo?
    
    @State private var title = ""
    @State private var description = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onAppear {
                        // Wenn wir ein bestehendes To-Do bearbeiten
                        if let editing = editingToDo {
                            // Nur setzen, wenn die Felder noch leer sind
                            if title.isEmpty && description.isEmpty {
                                title = editing.title
                                description = editing.description
                            }
                        } else {
                            // Neues To-Do -> Titel aus initialTitle
                            title = initialTitle
                        }
                    }

                TextEditor(text: $description)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()

                Spacer()

                Button {
                    guard !title.isEmpty else { return }

                    // Prüfen, ob bereits ein To-Do bearbeitet wird
                    if let index = todos.firstIndex(where: { $0.id == editingToDo?.id }) {
                        // Vorhandenes To-Do aktualisieren
                        todos[index].title = title
                        todos[index].description = description
                        onSave()
                        dismiss()
                    }
                    else if !todos.contains(where: { $0.title == title && $0.description == description }) {
                        // Neues To-Do anlegen
                        todos.append(ToDo(title: title, description: description))
                        onSave()
                        dismiss()
                    } else {
                        // Doppeltes To-Do
                        alertMessage = "To-Do already exists!"
                        showAlert = true
                    }
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .alert("Fehler", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
            }
            .navigationTitle(editingToDo == nil ? "New To-Do" : "Edit To-Do")
        }
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(
            todos: .constant([]),
            initialTitle: .constant(""),
            editingToDo: .constant(ToDo(title: "Example", description: "This is a test.")),
            onSave: {}
        )
    }
}



