//
//  ListController.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 13.12.2023.
//

import UIKit

class ListController: UIViewController {
    
    //MARK: - Properties
    private let noteManager = NoteManager()
    //MARK: - UI
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        configureTableView()
        configureNavBar()
    }
}

//MARK: - Methods
private extension ListController {
    func setupView() {
        view.backgroundColor = .white
        title = Constants.NavBar.mainTitle
        
        view.addSubview(tableView)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableView.cellID)
        tableView.bounces = false
    }
    
    func configureNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        let editButton = UIBarButtonItem(title: Constants.NavBar.editTitle, style: .plain, target: self, action: #selector(editTableView))
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
    }
    
    @objc func editTableView() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let navigationItem = self.navigationItem.rightBarButtonItems!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch self.tableView.isEditing {
            case true:
                navigationItem[1].title = Constants.NavBar.doneTitle
                navigationItem[0].isEnabled = false
            case false:
                navigationItem[1].title = Constants.NavBar.editTitle
                navigationItem[0].isEnabled = true
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func addButtonPressed() {
        noteManager.showAlert(in: self) { [weak self] text in
            self?.noteManager.addNote(name: text)
            self?.tableView.reloadData()
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate & DataSource
extension ListController: UITableViewDelegate {
    //Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            noteManager.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Rename
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Rename") { _, _, completion in
            self.noteManager.showAlert(in: self) { [weak self] text in
                self?.noteManager.removeNote(at: indexPath.row)
                self?.noteManager.notes.insert(contentsOf: [Note(name: text)], at: indexPath.row)
                self?.noteManager.setBadge()
                self?.tableView.reloadData(with: .automatic)
                completion(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if noteManager.changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = .check
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = .blank
        }
    }
    
    //change cells between each other
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        noteManager.moveNote(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
}

extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteManager.notes.count
    }
    
    //Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.TableView.cellID)
        let currentNote = noteManager.notes[indexPath.row]
        
        cell.textLabel?.text = currentNote.name
        if noteManager.notes[indexPath.row].isCompleted {
            cell.imageView?.image = .check
        } else {
            cell.imageView?.image = .blank
        }
        
        switch tableView.isEditing {
        case true:
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        case false:
            cell.textLabel?.alpha = 1
            cell.textLabel?.alpha = 1
        }
        
        return cell
    }
}
