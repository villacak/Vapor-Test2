Vapor-Test2

If you don't have brew and mysql installed please follow the next steps, if you do it's just checkout the project and go to starting.

To install Brew, from this link: http://brew.sh

Then install MySQL using **brew install mysql**

Start MySQL, with: **mysql.server start**, to stop it type: **mysql.server stop**

Set your root password, check the following link: http://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html

Create your user: http://dev.mysql.com/doc/refman/5.7/en/adding-users.html

Create the database/schema: http://dev.mysql.com/doc/refman/5.7/en/creating-database.html;

Then update the *\<projectName\>Config/secrets/mysql.json* to match your server, user, password and database name created.


#Starting
From commandline and from within the project directory type, **vapor clean** and then **vapor xcode --mysql**

Accept the open to xCode with y

Go to Sources/Fluent/Entity/Entity.swift and on line 79 comment the string concatenation, as shown:
**return name //+ "s"**

Change to run as an app (basically at the right from where you would run the project) and run it.

Then you can run it from web browser (not post requests) or from a REST client, like Paw or Postman.

Those request example are part of the App/main.swift functions comments.


# From Vapor
# Basic Template

A basic vapor template for starting a new Vapor web application. If you're using vapor toolbox, you can use: `vapor new --template=basic`

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.
