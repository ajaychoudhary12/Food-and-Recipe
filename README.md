# Food and Recipe

Food and Recipe is an app that lets a user to search recipes through spoonacular API and enable users to save favourite recipes in their app offline.

## App Features

1. Search recipes online through spoonacular API.
2. Save user's favourite recipes offline.


## Implementation

The app contains 6 View Controllers :
1. HomeViewController - It shows random recipes from the API in a Table View and also has a refresh button to get more random recipes.
2. SearchViewController - It lets a user to search a recipe by typing the query in the search bar. It contains a Table View showing autocomplete suggestions of the query.
3. SavedViewController - It shows the recipes saved by a user.
4. SearchResultsViewController - Clicking an autocomplete suggestion in SearchViewController actually searches and shows the search results in this View Controller in a Table View.
5. DetailViewController - Clicking on a recipe, from either of the View Controllers (Home, Saved and SearchResults) takes the user to this view. It shows the details of the selected recipe, the title, time required, image and ingredients of the recipe. It also contains an "Instructions" button that present the instructions of the recipe in the InstructionViewController.
6. InstructionsViewController - This view controller shows the instructions of the recipe when clicked on the "Instructions" button from the DetailViewController.

## How to build/compile
1. Open "Food and Recipe.xcodeproj" file.
2. Select appropriate simulator.
3. Click the run button or command + R to run the project.

## Requirements
1. Xcode 10.3
2. Swift 5

## APIs used
1. https://spoonacular.com/food-api/docs

## Screenshots 
<img src = "Screenshots/Home.PNG" width = "180">  &nbsp; <img src = "Screenshots/Search.PNG" width = "180"> &nbsp; <img src = "Screenshots/SearchResults.PNG" width = "180"> &nbsp; <img src = "Screenshots/Saved.PNG" width = "180"> &nbsp; <img src = "Screenshots/Detail.PNG" width = "180"> &nbsp; <img src = "Screenshots/Instructions.PNG" width = "180">

## License
This code is free and open source.
