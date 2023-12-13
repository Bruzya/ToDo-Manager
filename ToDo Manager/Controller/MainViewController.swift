//
//  MainViewController.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 13.12.2023.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Properties
    var notes: [Note] = [Note(name: "Test note")]
    
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
private extension MainViewController {
    func setupView() {
        view.backgroundColor = .lightGray
        title = "Note"

        view.addSubview(tableView)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bounces = false
    }
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAlert))
    }
    
    @objc func openAlert() {
        let alert = UIAlertController(title: "Create note", message: nil, preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            if let textName = alert.textFields?.first?.text {
                self.addNote(textName)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        present(alert, animated:  true)
    }
    
    func addNote(_ name: String) {
        notes.append(Note(name: name))
        tableView.reloadData()
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
extension MainViewController: UITableViewDelegate {
    //Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notes[indexPath.row].isCompleted = true
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    //Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.name
        
        //Checkmark
        switch notes[indexPath.row].isCompleted {
        case true: 
            cell.accessoryType = .checkmark
        case false:
            cell.accessoryType = .none
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        return cell
    }
}
