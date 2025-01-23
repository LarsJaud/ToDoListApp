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
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .onAppear {
                        // edit an existing to-do
                        if let editing = editingToDo {
                            // only set if the fields are still empty
                            if title.isEmpty && description.isEmpty {
                                title = editing.title
                                description = editing.description
                            }
                        } else {
                            // new to-do -> title from initialTitle
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

                    // check whether a to-do is already being processed
                    if let index = todos.firstIndex(where: { $0.id == editingToDo?.id }) {
                        // update existing to-do
                        todos[index].title = title
                        todos[index].description = description
                        onSave()
                        dismiss()
                    }
                    else if !todos.contains(where: { $0.title == title && $0.description == description }) {
                        // create new To-do
                        todos.append(ToDo(title: title, description: description))
                        onSave()
                        dismiss()
                    } else {
                        // to-do already exists
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editingToDo == nil ? "New To-Do" : "Edit To-Do")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(
            todos: .constant([]),
            initialTitle: .constant(""),
            editingToDo: .constant(ToDo(title: "", description: "")),
            onSave: {}
        )
    }
}



