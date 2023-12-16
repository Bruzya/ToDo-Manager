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
        static let leadingSwipe = "Rename"
    }
    
    enum NavBar {
        static let mainTitle = "Notes"
        static let doneTitle = "Done"
        static let editTitle = "Edit"
    }
    
    enum Alert {
        static let addTitle = "Create note"
        static let renameTitle = "Rename note"
        static let update = "Update"
        static let save = "Save"
        static let cancel = "Cancel"
    }
}
