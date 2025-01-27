//
//  ToDoDetailViewReadOnly.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 24.01.25.
//

import SwiftUI

struct ToDoDetailViewReadOnly: View {
    var todo: ToDo
    
    var body: some View {
        VStack(spacing: 20) {
            Text(todo.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            ScrollView {
                Text(todo.description)
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(todo.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToDoDetailViewReadonly_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailViewReadOnly(todo: ToDo(title: "", description: ""))
    }
}
