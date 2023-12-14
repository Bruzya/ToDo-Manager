//
//  Constants.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 14.12.2023.
//

import Foundation

struct Constants {
    enum UserDefaults {
        static let notesDataKey = "notesData"
    }
    
    enum TableView {
        static let cellID = "Cell"
    }
    
    enum NavBar {
        static let mainTitle = "Notes"
    }
    
    enum Alert {
        static let title = "Create note"
        static let save = "Save"
        static let cancel = "Cancel"
    }
}
