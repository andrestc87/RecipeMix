# RecipeMix
RecipeMix is the application that I created for my final proyect on the iOS Nanodegree program in Udacity.

This application will allow the users to find something to cook depending on what they would like to try out(italian, mexican, something involving chicken, pork for exmaple).
Here is a brief summary of what the user can expect from the app:

### Login Screen
In this screen, the user will need to either register or log in into the app using:
- Email/Password
- Google Account
- Facebook Account
For all the login integration I used FireBase: https://firebase.google.com/


### Recipe Dashboard Tab
In this screen, the user will get a list of random recipes from where they could see what can cook, if the user does not see something they like, they can search for something they will like to cook. Once the user sees something they can tap on the recipe and they will see the Recipe Detail Screen, in there the user will see all the information they need, for example, the summary of the recipe and the instructions, besides that there are a couple of buttons:
- Add To My Recipes: The recipe gets added to the user's recipe selection. This information is stored using Core Data.
- View Ingredients: The user is navigated to the Ingredients screen, here the user can see all the ingredients from the recipe, if the user, before entering to this screen, adds the recipe they will see a button to add those ingredientes to their Groceries List.


### My Selection Tab
In this screen, the user will see the recipes that he/she added to their selection, this list is populated with the information stored in Core Data, this list is ordered by registered date. If the user taps on a recipe, they will see the Recipe Detail screen mentioned above. Again, all this information is from what the user previously saved.


### Groceries List Tab
In this screen, the user will see a table with sections per Recipe added so they can see the ingredients for each recipe that they added ordered so they can see the last recipe saved first. Besided that, there is a floating button for looking for nearby places where they can go to buy the groceries needed, this map is populated with places such as: convenience stores, food stores, markets, food mart, grocery store, if the user taps on any location, they will see the annotation with th info button, after tapping on it, they will see the native get Directions apple component that will help the user to go to the store using as starting point their location.


# Built With
- API for the Recipes: https://spoonacular.com/ (With limitations due the use of the free plan)
- Firebase: https://firebase.google.com/ (Authentication)
- GoogleSignIn: Authentication with Google Account
- FacebookLogin: Authentication with Facebook account
- Kinsfisher: https://github.com/onevcat/Kingfisher (Image download management)
- SkeletonView: https://github.com/Juanpe/SkeletonView (Provides an elegant way to show users that something is happening and also prepare them for which contents are waiting.)


# Author
- Andres Tello Campos: https://github.com/andrestc87


