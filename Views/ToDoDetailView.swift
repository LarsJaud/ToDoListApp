//
//  ToDoDetailView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//
import SwiftUI
import Foundation

struct ToDoDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var todos: [ToDo]
    @Binding var initialTitle: String
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onAppear{
                        self.title = initialTitle
                    }

                TextEditor(text: $description)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()

                Spacer()

                Button(action: {
                    if !title.isEmpty {
                        if !todos.contains(where: { $0.title == title && $0.description == description }) {
                            todos.append(ToDo(title: title, description: description))
                            onSave()
                            dismiss()
                        } else {
                            alertMessage = "To-Do already exists!"
                            showAlert = true
                        }
                    }
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("Fehler"),
                        message: Text(alertMessage),
                        dismissButton: .cancel(Text("OK"))
                    )
                }
            }
            .navigationTitle("New To-Do")
        }
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(todos: .constant([]), initialTitle: .constant(""), onSave: {})
    }
}


