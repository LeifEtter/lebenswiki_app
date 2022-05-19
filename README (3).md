
# Digestify

A simple tool to log foods and use them to create meals while keeping track of the contained allergens.


## Setting up the Environment

Prerequisites:
* An IDE
* Python

#### Create and open a project folder with chosen IDE and run these commands:

```console
pip3 install virtualenv
virtualenv env
source env/bin/activate
pip3 install flask flask-sqlalchemy
```

## Explanation of the Website

The websites main functionality is to let the user create food items, as well meal items. These two Models have a realtionship of "Many to Many" to eachother.
This means that a food item can be part of a meal.


These are the models:
```
class Meal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    ingredients = db.relationship('Food', secondary=food_meal, backref="meals")
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

class Food(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    allergens = db.Column(db.String)
    calories = db.Column(db.INT)
```

This is the Table that represents the models relationship:
```
food_meal = db.Table('food_meal',
    db.Column('meal_id', db.Integer, db.ForeignKey('meal.id')),
    db.Column('food_id', db.Integer, db.ForeignKey('food.id'))
)
```

The website consists of 6 main routes:
* foods -> Shows all food items
* meals -> Shows all meal items
* createFood -> Lets user create a food item
* editFood -> Lets user edit a food item
* createMeal -> Lets user create a meal item
* deleteFood -> Delets a food given its id


### Theoretical Authentication

As i didn't implement the functionality for login and registering i will explain how i would have done it.

I would first create a User Model in SQL Alchemy, somewhat like this in pseudocode:
```
User
    id: Int
    name: String
    email: String
    password: String
```

I would then create the routes for Login, Register, and Logout, as well as the html pages with the forms. The forms would be of method "POST".

To aid i would probably install flask-login as my plugin for authentication.

My Signup would look something like this in pseudocode:
```
get all info from formdata
check if email already exists in database, if so prompt user to enter a different open
otherwise save data, as well as hashed version of password into database
now redirect user to login page
```

My login would look as follows:
```
get all form data
check if user either doesnt exists in db or if the password doesnt match the email, if so, prompt user to reenter details
otherwise direct user to the homepage, or in my case the foods page
```

To ensure that the user is authenticated correctly we want to either send the user a token, which he will save client-side and use to authenticate himself when accesing a protected page, or we will have something like a manager to manage the users session.

At last we want to protect the routes, that the user requires a token for. We will du this by calling a function that requests authentication from the user.
If we have data that is related to him, we can also show the data accordingly based on the authentication.


### Request/Response Flow
https://imgur.com/a/LS5kAlg

