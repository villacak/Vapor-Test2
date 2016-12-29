//
//  Login.swift
//  vaportest2
//
//  Created by Villaca, Klaus on 12/21/16.
//
//

import Vapor
import Fluent
import Foundation

final class Login: Model {
    
    var exists: Bool = false
    var id: Node?
    
    var logincol: String
    var password: String
    var lastaccess: String
    var status: String
    
    init(logincol: String, password: String, lastaccess: String, status: String) {
        self.id = nil
        self.logincol = logincol
        self.password = password
        self.lastaccess = lastaccess
        self.status = status
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        logincol = try node.extract("logincol")
        password = try node.extract("password")
        lastaccess = try node.extract("lastaccess")
        status = try node.extract("status")
    }
    
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "logincol": logincol,
            "password": password,
            "lastaccess": lastaccess,
            "status": status
            ])
    }
}

extension Login: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("login") { logins in
            logins.id()
            logins.string("logincol")
            logins.string("password")
            logins.string("lastaccess")
            logins.string("status")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("login")
    }
}
