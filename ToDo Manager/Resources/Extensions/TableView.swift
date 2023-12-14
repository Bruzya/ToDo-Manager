//
//  TableView.swift
//  ToDo Manager
//
//  Created by Evgenii Mazrukho on 14.12.2023.
//

import UIKit

//add animation on reloadData
extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
