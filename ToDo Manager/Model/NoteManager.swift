//
//  NoteManager.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 14.12.2023.
//

import Foundation

final class NoteManager {
    
    //MARK: - Properties
    let defaults = UserDefaults.standard
    //get and set userDefaults
    var notes: [Note] {
        get {
            if let data = defaults.value(forKey: Constants.UserDefaults.notesDataKey) as? Data {
                return try! PropertyListDecoder().decode([Note].self, from: data)
            } else {
                return [Note]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: Constants.UserDefaults.notesDataKey)
            }
        }
    }
}

//MARK: - Methods
extension NoteManager {
    func addNote(name: String) {
        notes.append(Note(name: name))
    }
    
    func removeNote(at index: Int) {
        notes.remove(at: index)
    }
    
    func changeState(at index: Int) -> Bool {
        notes[index].isCompleted = !notes[index].isCompleted
        return notes[index].isCompleted
    }
    
    func moveNote(from sourceIndex: Int, to destinationIndex: Int) {
        let source = notes[sourceIndex]
        notes.remove(at: sourceIndex)
        notes.insert(source, at: destinationIndex)
    }
}
