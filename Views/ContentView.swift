import SwiftUI

struct ContentView: View {
    @State private var todos: [ToDo] = []
    @State private var isDarkMode = false
    @State private var showDetailView = false
    @State private var selectedTodo: ToDo? = nil
    
    private let todosKey = "com.larsjaud.todos"

    var body: some View {
        NavigationView {
            VStack {
                // list of all to-dos
                List {
                    ForEach(todos) { todo in
                        VStack(alignment: .leading) {
                            Text(todo.title)
                                .font(.headline)
                            Text(todo.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                delete(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                edit(todo)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    VStack {
                        Text("To-Do-List")
                            .font(.title)
                            .padding(.top, 40)
                    }
                }
                // Dark-Mode-toggle
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.mint)
                    }
                }
                
                // Button for the new to-do
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDetailView.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.mint)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showDetailView) {
                // detail/edit view
                ToDoDetailView(
                    todos: $todos,
                    initialTitle: .constant(selectedTodo?.title ?? ""),
                    editingToDo: $selectedTodo,
                    onSave: saveToDos
                )
            }
            .onAppear(perform: loadToDos)
        }
        // reset the selected to-do after closing the sheet
        .onChange(of: showDetailView) { oldValue, newValue in
            if !newValue { selectedTodo = nil }
        }
    }

    /// removes a to-do from the list and saves again
    private func delete(_ todo: ToDo) {
        if let index = todos.firstIndex(of: todo) {
            todos.remove(at: index)
            saveToDos()
        }
    }

    /// open the sheet to edit an existing to-do
    private func edit(_ todo: ToDo) {
        selectedTodo = todo
        showDetailView = true
    }

    /// save the list of to-dos from UserDefaults
    private func saveToDos() {
        do {
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: todosKey)
        } catch {
            print("Error saving To-Dos:", error.localizedDescription)
        }
    }

    /// loads the list of to-dos from UserDefaults
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
