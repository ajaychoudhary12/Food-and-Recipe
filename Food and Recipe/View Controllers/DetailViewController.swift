//
//  DetailViewController.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 29/09/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var recipe: Recipe!
    var ingredients = [String]()
    let instructionsButton = UIButton()
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ingredients = recipe.ingredients {
            self.ingredients = ingredients
        }
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setupTableView()
        setupNavigationButtons()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK:- Setup Navigation Buttons
    
    private func setupNavigationButtons() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTheView))
        self.navigationItem.leftBarButtonItem = backButton
        let instructionsButton = UIBarButtonItem(title: "Instructions", style: .plain, target: self, action: #selector(showInstructions))
        self.navigationItem.rightBarButtonItem = instructionsButton
    }
    
    @objc func dismissTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInstructions() {
        if let instructions = recipe.instructions {
            if instructions.count == 0 {
                if let url = URL(string: recipe.sourceURL ?? "") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        self.presentAlert(title: "Instructions Unavailable", message: "")
                    }
                } else {
                    self.presentAlert(title: "Instructions Unavailable", message: "")
                }
            } else {
                let instructionsVC = InstructionsViewController()
                instructionsVC.recipe = recipe
                self.navigationController?.pushViewController(instructionsVC, animated: true)
            }
        } else {
            presentAlert(title: "Instructions Unavailable", message: "")
        }
    }
    
}

    //MARK: - Setup TableView

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.width
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderCell()
        if let title = recipe.title  {
            headerView.recipeTitleLabel.text = title
        }
        if let time = recipe.timeRequired {
            headerView.timingLabel.text = " Time Required: \(time) Minutes"
        }
        if let imageURL = recipe.imageURL {
            SpoonacularClient.downloadRecipeImage(imageURL: imageURL) { (image) in
                DispatchQueue.main.async {
                    headerView.imageView.image = image
                }
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
        cell.textLabel?.text = "\(indexPath.row + 1). \(ingredient)"
        return cell
    }
}



