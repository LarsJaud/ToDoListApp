//
//  ToDo.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//

import Foundation

struct ToDo: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String

    // Initializer für neue To-Dos
    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}

