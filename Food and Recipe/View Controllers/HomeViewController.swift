//
//  ViewController.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 26/09/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        SpoonacularClient.getRandomRecipe(completion: handleImageURL(recipes:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func handleImageURL(recipes: [Recipe]) {
        self.recipes = recipes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeTitle.text = recipe.title
        cell.durationTitle.text = String("\(recipe.timeRequired!) minutes")
        cell.recipeImageView.image = UIImage(named: "imagePlaceholder")
        if let imageURL = recipe.imageURL {
            SpoonacularClient.downloadRecipeImage(imageURL: imageURL) { (image) in
                DispatchQueue.main.async {
                    cell.recipeImageView.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailVC.recipe = recipe
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}





