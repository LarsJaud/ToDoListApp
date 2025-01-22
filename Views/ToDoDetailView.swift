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
    @State private var title: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Titel eingeben", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

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
                        todos.append(ToDo(title: title, description: description))
                        dismiss()
                    }
                }) {
                    Text("Hinzufügen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Neues To-Do")
        }
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(todos: .constant([]))
    }
}


