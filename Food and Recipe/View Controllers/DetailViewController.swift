//
//  DetailViewController.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 29/09/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var recipe: Recipe!
    var ingredients = [String]()
    let instructionsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = recipe.ingredients!
        setup()
        if let imageURL = recipe.imageURL {
            SpoonacularClient.downloadRecipeImage(imageURL: imageURL) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    } 
    
    private func setup() {
        titleLabel.text = recipe.title!
        self.tabBarController?.tabBar.isHidden = true
        setupTableView()
        setupNavigationButtons()
        setupInstructionsButton()
    }
    
    private func setupTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.estimatedRowHeight = 85.0
        ingredientsTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupNavigationButtons() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTheView))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupInstructionsButton() {
        view.addSubview(instructionsButton)
        
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        instructionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        instructionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        instructionsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        instructionsButton.setTitle("Instructions", for: .normal)
        instructionsButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 20)
        instructionsButton.setTitleColor(.white, for: .normal)
        instructionsButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        instructionsButton.addTarget(self, action: #selector(showInstructions), for: .touchUpInside)
    }
    
    @objc func showInstructions() {
        let instructionsVC = storyboard?.instantiateViewController(withIdentifier: "InstructionsVC") as! InstructionsViewController
        instructionsVC.instructions = recipe.instructions!
        self.navigationController?.pushViewController(instructionsVC, animated: true)
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! IngredientCell
        cell.label.text = ingredients[indexPath.row]
        return cell
    }
}



