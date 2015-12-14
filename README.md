# ExpressJS, front-end & storage

## Authors
- Vincent Rakotomanga
- Houssam Kamal

## About this code

Project is developed using [coffee](http://coffeescript.org/) and [jade](http://jade-lang.com/).

Tests are developed using [mocha](http://mochajs.org/) and [should](http://shouldjs.github.io/).

Before anything : `npm install` && `chmod 755 bin/*`

- `./bin/build` to compile the coffee code to javascript
- `./bin/populatedb` to add some metrics in the db
- `./bin/test` to run the tests
- `./bin/start` to run the code

## About this work

This work is part of the continuous assessment of the ECE Asynchronous Technology
Class and will be the basis for your final project. Your final grade will be
calculated based on the final project’s result and your Git’s history.

The project in itself is a simple web dashboard that should allow you to :

- Login with a user
- Insert metrics once logged in
- Retrieve the user’s metrics and display it in a graph
- Only access the user’s metrics, not the rest of it

In class, we saw how to :

- Use Nodemon to launch our application, so we don’t have to relaunch the server every time
- Create an ExpressJS app to facilitate Routing, use of HTTP verbs and exposing a front-end
- Create a simple front-end in Jade with some AJAX call to add data dynamically to our webage
- Use a LevelDB database to store our metrics
- Create a coffee script to populate our database with dummy data so we don’t have to do it manually

The project shall be written in coffee-script, jade and stylus and nothing else. You are encouraged to use the tools presented in class.


## TODO

Using the code from your previous work and from class :
- On the front-end
  - Work with Stylus and Bootstrap to make it look nice
  - Display the metrics in a graph using d3.js
- On the back-end
  - Add *get* and *remove* functions to the metrics module to retrieve and remove data from the database
  - Use postman to test your API functions
  - Enhance the *populatedb* script that we saw in class to add multiple metric batches with different IDs

This is not the complete code since the beginning, only today's. I’ll remove it
next monday.
You could of course if you want take the code and go from here adding what we
did previously however that’s your loss because you won’t learn as much as
doing it by yourself and it can be noticed.

Also, you don’t have to but, you could develop your *get* and *remove* functions
using unit testing, it is going to be much easier to test than with another
process. I added a unit test skeleton on the get function in the test directory
as example.


## Some useful links

- [Stylus documentation](https://learnboost.github.io/stylus/)
- [Jade documentation](http://jade-lang.com/)
- [Coffee-script documentation](http://coffeescript.org/)
- [D3.JS documentation](http://d3js.org/)
- [JQuery documentation](http://code.jquery.com)
- [Bootstrap documentation](http://getbootstrap.com/)
- [Level-up documentation](https://github.com/Level/levelup)