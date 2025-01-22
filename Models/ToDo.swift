//
//  ToDo.swift
//  ToDoListApp
//
//  Created by Lars Jaud on 22.01.25.
//

import Foundation

struct ToDo: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var description: String
}
