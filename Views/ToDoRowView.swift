//
//  ToDoRowView.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 23.01.25.
//

import SwiftUI

struct ToDoRowView: View {
    @Binding var todo: ToDo
    var onSave: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Checkmark-Button
            Button(action: {
                todo.isCompleted.toggle()
                onSave()
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.system(size: 22))
            }
            .buttonStyle(BorderlessButtonStyle())

            // title and description
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .strikethrough(todo.isCompleted, color: colorScheme == .dark ? .black : .gray)

                Text(todo.description)
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? Color(white: 0.97) : .gray)
                    .strikethrough(todo.isCompleted, color: colorScheme == .dark ? .black : .gray)
            }
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(white: 0.97))
                .shadow(color: Color.black.opacity(0), radius: 3, x: 0, y: 2)
        )
    }
}

struct ToDoRowView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRowView(todo: .constant(ToDo(title: "", description: "", isCompleted: false))){
            
        }
    }
}
