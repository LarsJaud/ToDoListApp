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
                ToDoDetailView(todos: $todos, initialTitle: $newTodo)
            }
        }
    }

    private func addTodo() {
        if !newTodo.isEmpty {
            todos.append(ToDo(title: newTodo, description: ""))
            newTodo = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


