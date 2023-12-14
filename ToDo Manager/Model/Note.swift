//
//  Note.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 13.12.2023.
//

import Foundation

struct Note: Codable {
    var name: String
    var id: UUID = UUID()
    var isCompleted: Bool = false
}
