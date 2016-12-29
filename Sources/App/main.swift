import Vapor
import VaporMySQL

let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)

// Init driver for fluent
let driver = drop.database?.driver as? MySQLDriver
Database.default = Database(driver!)


// Uncomment if you want to delete and create new table
//try Login.revert(drop.database!)
//try Login.prepare(drop.database!)



// http://localhost:8090/test
// If on a web browser it should load a page, if in any REST client you should be able to see the page code
drop.get("test") { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}


// http://localhost:8090/hello?name=<someString>
drop.get("hello") {
    request in
    guard let name = request.data["name"]?.string else {
        throw Abort.custom(status: .badRequest, message: "missing parameter name, eg: hello?name='<some name>'")
    }
    let customKey: String = drop.config["server", "http", "securityLayer", "custom-key"]?.string ?? "default"
    let stringReturn: String = "Hello, \(name), server has a custom-key: \(customKey)!"
    return stringReturn
}


// http://localhost:8090/hello?name=<someString>
// The same as above though this is a POST call
drop.post("hello") {
    request in
    guard let name = request.data["name"]?.string else {
        throw Abort.custom(status: .badRequest, message: "missing or wrong JSON, eg: {'name': '<someString>'}")
    }
    return "Hello, \(name)!"
}


// http://localhost:8090/version
drop.get("version") {
    request in
    return try JSON(node: ["version": "1.0T"])
}


// http://localhost:8090/dbversion
// DB must be up and running, will return the DB version as JSON
drop.get("dbversion") {
    request in
    if let _ = driver {
        let version = try driver?.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return"No DB connection"
    }
}


// http://localhost:8090/new
// JSON as raw data:
// {
//  "logincol": "mylogin",
//  "password": "myPassword",
//  "lastaccess": "<MySQLDateTimeFormat>",
//  "status": "OK"
// }
// MySQLDateTimeFormat is yyyy-MM-dd HH:mm:ss.S, 2016-12-21 10:10:03.1
drop.post("new") { request in
    var login = try Login(node: request.json)
    try login.save()
    return login
}



// http://localhost:8090/newoldstyle
// Using SELECT to add a new record.
// JSON as raw data:
// {
//  "logincol": "mylogin",
//  "password": "myPassword",
//  "lastaccess": "<MySQLDateTimeFormat>",
//  "status": "OK"
// }
// MySQLDateTimeFormat is yyyy-MM-dd HH:mm:ss.S, 2016-12-21 10:10:03.1
drop.post("newoldstyle") { request in
        if let _ = driver {
            var login: Login = try Login(node: request.json)
            let query: String = "INSERT INTO login (logincol, password, lastaccess, status) values ('\(login.logincol)', '\(login.password)', '\(login.lastaccess)', '\(login.status)')"
            let firstLoginFromDB = try driver?.raw(query)
            let firstLogin = try JSON(node: firstLoginFromDB?.makeNode())
            return try JSON(node: firstLogin)
        } else {
            return"No DB connection"
        }
}


// http://localhost:8090/all
drop.get("all") { request in
    return try JSON(node: Login.all().makeNode())
}


// http://localhost:8090/first
drop.get("first") { request in
    guard let login: Login = try Login.query().first() else {
        throw Abort.notFound
    }
    return try JSON(node: login.makeNode())
}


// http://localhost:8090/firstoldstyle
// Using SELECT to retrieve the first record.
drop.get("first") { request in
        if let _ = driver {
            let firstLoginFromDB = try driver?.raw("SELECT * FROM login LIMIT 1")
            let firstLogin = try JSON(node: firstLoginFromDB?.makeNode())
            return try JSON(node: firstLogin)
        } else {
            return"No DB connection"
        }
}


// http://localhost:8090/search?query=<typeYourSearch>
drop.get("search") { request in
    guard let searchQuery = request.data["query"]?.string else {
        throw Abort.custom(status: .badRequest, message: "missing or wrong JSON, eg: {'query': '<stringForSearch>'}")
    }
    return try JSON(node: Login.query().filter("logincol", searchQuery).all().makeNode())
}


// http://localhost:8090/update?login=<loginId>
// JSON as raw data:
// {
//  "logincol": "newlogin",
//  "password": "newPassword",
//  "lastaccess": "new <MySQLDateTimeFormat>",
//  "status": "OK"
// }
// MySQLDateTimeFormat is yyyy-MM-dd HH:mm:ss.S, 2016-12-21 10:10:03.1
drop.post("update") { request in
    guard let loginId = request.data["login"]?.string else {
        throw Abort.custom(status: .badRequest, message: "missing or wrong JSON, eg: {'login': '<loginIdForSearch>'}")
    }
    
    let records: [Login] = try Login.query().filter("logincol", loginId).all()
    if records.count == 0 {
        throw Abort.custom(status: .accepted, message: "There's no record with login id \(loginId) to update")
    }
    
    var tempRecord: Login = records[0]
    try tempRecord.save()
    return tempRecord;
    
}


// http://localhost:8090/delete?query=<typeYourSearch>
drop.get("delete") { request in
    guard let searchQuery = request.data["query"]?.string else {
        throw Abort.custom(status: .badRequest, message: "missing or wrong JSON, eg: {'query': '<stringFoDelete'}")
    }
    let query = try Login.query().filter("logincol", searchQuery)
    try query.delete()
    return try JSON(node: Login.all().makeNode())
}


drop.resource("posts", PostController())

drop.run()
