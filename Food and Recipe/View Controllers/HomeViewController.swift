//
//  ViewController.swift
//  Food and Recipe
//
//  Created by Ajay Choudhary on 26/09/19.
//  Copyright © 2019 Ajay Choudhary. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var activityIndicatorContainer: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setup() {
        self.title = "Feed"
        setupTableView()
        setupActivityIndicator()
        showActivityIndicator(show: true)
        SpoonacularClient.getRandomRecipe(completion: handleRecipes)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupActivityIndicator() {
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = view.center.x
        activityIndicatorContainer.center.y = view.center.y
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.8
        activityIndicatorContainer.layer.cornerRadius = 10
          
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.addSubview(activityIndicator)
        view.addSubview(activityIndicatorContainer)
            
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
    
    private func showActivityIndicator(show: Bool) {
      if show {
        DispatchQueue.main.async{
            self.tableView.allowsSelection = false
            self.activityIndicator.startAnimating()
            self.refreshButton.isEnabled = false
        }
      } else {
            DispatchQueue.main.async{
                self.tableView.allowsSelection = true
                self.refreshButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicatorContainer.removeFromSuperview()
            }
        }
    }
    
    
    func handleRecipes(recipes: [Recipe]) {
        self.showActivityIndicator(show: false)
        if recipes.count == 0 {
            DispatchQueue.main.async {
                self.presentAlert(title: "Feed Unavailable", message: "Unable to get Feed at the moment")
            }
        }
        self.recipes = recipes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        setupActivityIndicator()
        showActivityIndicator(show: true)
        SpoonacularClient.getRandomRecipe(completion: handleRecipes)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecipeCell
        let recipe = recipes[indexPath.row]
        if let title = recipe.title {
            cell.recipeTitle.text = title
        }
        if let time = recipe.timeRequired {
            cell.durationTitle.text = String("\(time) minutes")
        }
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
        if recipe.ingredients?.count == 0 {
            if let url = URL(string: recipe.sourceURL ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        } else {
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
            detailVC.recipe = recipe
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}





