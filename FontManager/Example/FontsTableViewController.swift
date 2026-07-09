//
//  FontsTableViewController.swift
//  Example
//
//  Created by Ben Shutt on 22/02/2020.
//

import UIKit
import FontManager

// MARK: - FontsTableViewController

class FontsTableViewController: UITableViewController {

    private lazy var textStyles = UIFont.TextStyle.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        
        let identifier = "\(UITableViewCell.self)"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textStyles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(UITableViewCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let textStyle = textStyles[indexPath.row]
        cell.textLabel?.text = textStyle.description
        cell.textLabel?.font = Font.font(forTextStyle: textStyle)
        
        return cell
    }

}
