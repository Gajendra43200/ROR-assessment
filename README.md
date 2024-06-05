# README
## Project Name - ROR-Assessment

## Description
This project is a blogging platform built with Ruby on Rails. It includes user authentication(JWT) with two-factor authentication (2FA)(use rotp and  rqrcode gem), blog post management, a commenting system, role-based access control (RBAC), pagination, filtering, sorting, full-text search, a RESTful API, and integration with a news article API.
## Install the necessary dependencies or gems and set up the database or run server.
* bundle install
* rails db:create
* rails db:migrate
* rails s
* Ruby version - 3.2.2
* Rails version - ~> 7.0.8', '>= 7.0.8.3
* Database - PostgraSql as the database for Active Record

## For Routes
* To find routes related to a specific controller (e.g., users), you can use the following command:
* rails routes | grep users
* rails routes (for all routes)
* I am also attached postman collection.


## Run the Test Suite
* To run the test suite using RSpec, you can use the following command: bundle exec rspec spec
* This command will run all the spec files in the spec directory. If you want to run a specific file, you can specify the path: bundle exec rspec spec/path/to/your/file_spec.rb
* Replace path/to/your/file_spec.rb with the actual path to your spec file.

## Features Of Project 

## User Authentication and Management
* Users can create an account and authenticate themselves(JWT).
* Implement two-factor authentication (2FA) for enhanced security(rotp,qrcode gem used).

## Blog Posts Management
* Users can create, edit, and delete blog posts.
* Posts include a title, body, images, and timestamps.
* For timestamp i used created cliumn of post.
* Use Active Storage user can add image in post.
* Users can like blog posts. Likes are tracked in the database and associated with both the user and the post.
* Users can view a list of all blog posts, including the post title, author, and a snippet of the body.

## Comments System
* Users can comment on blog posts. Comments include a body.
* Implemented email notifications for new comments and likes using action mailer.

## Role-Based Access Control (RBAC)
* Implemented  role-based access control system with roles like Author and Reader Useing CanCan gem.
* Author:
* Can create posts.
* Whean  user like and comment on other users' posts so send notification by email to  outhor of post usining  action_mailer.
* Reader:
* Cannot create posts.
* Can like and comment on other users' posts.
* Users can decide their role during registration.
* Additional Features
* Implemented pagination on the blog post listing page  useing kaminari gem.
* Implement filtering, sorting, and full-text search on the blog post listing page.

## RESTful API
* Listed all posts of a user with attributes: title, description, and author name.
* Show specific post with attributes: title, description, and author name.
* Listed comments on a specific post with attributes: comment, post_id, and commenter’s name.

## News Article Integration
* Created a services section for online news articles.
* Use free News article API  NewsAPI.
* Implemented methods to fetch news articles based on criteria such as top headlines.
* Designed views to display the fetched news articles.

## Testing
* Tests to verify that the app is working as expected using RSpec.

Contact
Name: Gajendra Patel
Email: gajendrapatel173@gmail.com
GitHub: https://github.com/Gajendra43200
