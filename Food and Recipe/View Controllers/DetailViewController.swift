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
    @IBOutlet weak var timeLabel: UILabel!
    
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
        timeLabel.text = "Time Required: \(recipe.timeRequired!) Minutes"
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
        let instructionsButton = UIBarButtonItem(title: "Instructions", style: .plain, target: self, action: #selector(showInstructions))
        self.navigationItem.rightBarButtonItem = instructionsButton
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



