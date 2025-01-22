//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [ToDo] = []
    @State private var newTodo: String = ""
    @State private var isDarkMode: Bool = false
    @State private var showDetailView = false
    private let todosKey = "com.larsjaud.todos"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    TextField("new To-Do", text: $newTodo)
                        .padding(10)
                        .background(isDarkMode ? Color.black : Color.white)
                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 2)
                        )
                        .frame(height: 44)
                        .padding(.leading, 16)

                    Button(action: {
                        showDetailView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(isDarkMode ? Color.gray : Color.mint)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .font(.system(size: 16))
                    }
                    .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                List {
                    ForEach(todos) { todo in
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.headline)
                            Text(todo.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = todos.firstIndex(of: todo) {
                                    todos.remove(at: index)
                                    saveToDos()
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("To-Do-List")
                        .font(.system(size: 28))
                        .bold()
                        .padding(.top, 20)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.mint)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showDetailView) {
                ToDoDetailView(todos: $todos, initialTitle: $newTodo, onSave: saveToDos)
            }
            .onAppear{
                loadToDos()
            }
        }
    }
    
    func saveToDos() {
        print("saveToDos wurde aufgerufen")
        do {
            let encoded = try JSONEncoder().encode(todos)
            print("Encodierte Daten: \(encoded)") // Rohdaten anzeigen
            UserDefaults.standard.set(encoded, forKey: todosKey)
            print("Daten erfolgreich gespeichert: \(todos)")
        } catch {
            print("Fehler beim Speichern der Daten: \(error.localizedDescription)")
        }
    }


    func loadToDos() {
        if let savedData = UserDefaults.standard.data(forKey: todosKey) {
            do {
                todos = try JSONDecoder().decode([ToDo].self, from: savedData)
                print("Daten erfolgreich geladen: \(todos)")
            } catch {
                print("Fehler beim Laden der Daten: \(error.localizedDescription)")
            }
        } else {
            print("Keine gespeicherten Daten gefunden")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


