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

            // title and description
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .strikethrough(todo.isCompleted, color: .gray)

                Text(todo.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .strikethrough(todo.isCompleted, color: .gray)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

struct ToDoRowView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRowView(todo: .constant(ToDo(title: "", description: "", isCompleted: false))){
            
        }
    }
}
