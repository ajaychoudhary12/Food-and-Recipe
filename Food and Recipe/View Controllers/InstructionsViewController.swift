//
//  InstructionsViewController.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 01/10/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    let instructionsTableView = UITableView()
    var instructions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = "Instructions"
        view.addSubview(instructionsTableView)
        
        instructionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        instructionsTableView.dataSource = self
        instructionsTableView.delegate = self
        
        instructionsTableView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        instructionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        instructionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        instructionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension InstructionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = instructions[indexPath.row]
        return cell!
    }
    
    
}
