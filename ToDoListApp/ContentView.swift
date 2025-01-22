//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [String] = []
    @State private var newTodo: String = ""
    @State private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView{
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
                        addTodo()
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(isDarkMode ? Color.gray : Color.mint)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .font(.system(size: 22))
                    }
                    .padding (.trailing, 16)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                List {
                    ForEach(todos, id: \.self) { todo in
                        Text(todo)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = todos.firstIndex(of: todo) {
                                        deleteTodo(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                    .onDelete(perform: deleteTodo)
                }

            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("To-Do-List")
                        .font(.system(size: 28))
                        .bold()
                        .padding(.top, 20)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.mint)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func addTodo() {
        if !newTodo.isEmpty {
            todos.append(newTodo)
            newTodo = ""
        }
    }
    
    private func deleteTodo(at offsets: IndexSet){
        todos.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
