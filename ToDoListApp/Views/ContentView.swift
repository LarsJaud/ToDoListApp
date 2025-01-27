//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [ToDo] = []
    @State private var isDarkMode = false
    @State private var showDetailView = false
    @State private var selectedTodo: ToDo? = nil
    
    private let todosKey = "com.testkey.todos"

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom header with title and icons
                HStack {
                    // Dark Mode toggle
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.mint)
                            .font(.title2)
                    }
                    
                    Spacer() // Space between buttons and title
                    
                    // Title
                    Text("To-Do-List")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer() // Space for right icon
                    
                    // Add button
                    Button {
                        showDetailView.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.mint)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemBackground))
                
                Divider() // Separator below header
                
                // List of to-dos
                List {
                    ForEach($todos) { $todo in
                        ToDoRowView(todo: $todo, onSave: saveToDos)
                            .swipeActions {
                                Button(role: .destructive) {
                                    delete(todo)                // delete to-dos
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    edit(todo)                  // edit to-dos
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                    .onMove { indices, newOffset in
                        todos.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showDetailView) {
                // Detail/edit view
                ToDoDetailView(
                    todos: $todos,
                    initialTitle: .constant(selectedTodo?.title ?? ""),
                    editingToDo: $selectedTodo,
                    onSave: saveToDos
                )
            }
            .onAppear(perform: loadToDos)
        }
    }

    /// Deletes a to-do from the list and saves changes
    private func delete(_ todo: ToDo) {
        if let index = todos.firstIndex(of: todo) {
            todos.remove(at: index)
            saveToDos()
        }
    }

    /// Opens the sheet to edit an existing to-do
    private func edit(_ todo: ToDo) {
        selectedTodo = todo
        showDetailView = true
    }

    /// Saves the to-dos to UserDefaults
    private func saveToDos() {
        do {
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: todosKey)
        } catch {
            print("Error saving To-Dos:", error.localizedDescription)
        }
    }

    /// Loads the to-dos from UserDefaults
    private func loadToDos() {
        if let data = UserDefaults.standard.data(forKey: todosKey) {
            do {
                todos = try JSONDecoder().decode([ToDo].self, from: data)
            } catch {
                print("Error loading To-Dos:", error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
