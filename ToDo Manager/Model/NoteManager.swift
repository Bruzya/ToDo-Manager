//
//  NoteManager.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 14.12.2023.
//

import UIKit
import UserNotifications

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
        setBadge()
    }
    
    func removeNote(at index: Int) {
        notes.remove(at: index)
        setBadge()
    }
    
    func changeState(at index: Int) -> Bool {
        notes[index].isCompleted = !notes[index].isCompleted
        setBadge()
        return notes[index].isCompleted
    }
    
    func moveNote(from sourceIndex: Int, to destinationIndex: Int) {
        let source = notes[sourceIndex]
        notes.remove(at: sourceIndex)
        notes.insert(source, at: destinationIndex)
    }
    
    func requestForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { isEnabled, error in
            if isEnabled {
                print("Accepted")
            } else {
                print("Denied")
            }
        }
    }
    
    func setBadge() {
        var totalBadgeNumber = 0
        for note in notes {
            if !note.isCompleted {
                totalBadgeNumber += 1
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
    }
    
    func showAlert(in viewController: UIViewController, completion: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: Constants.Alert.title, message: nil, preferredStyle: .alert)
        let saveButton = UIAlertAction(title: Constants.Alert.save, style: .default) { _ in
            if let text = alert.textFields?.first?.text, text != "" {
                completion(text)
            }
        }
        let cancelButton = UIAlertAction(title: Constants.Alert.cancel, style: .destructive)
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        alert.addTextField { textField in
            textField.placeholder = "New Note"
        }
        viewController.present(alert, animated: true)
    }
}
