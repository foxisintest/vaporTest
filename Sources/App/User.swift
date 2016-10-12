//
//  User.swift
//  NetworkTest
//
//  Created by Aboo on 2016/9/29.
//
//

import Vapor
import Fluent

class User123: Model {
    
    var id:Node?
    var name:String?
    var phone:String?
    var pw:String?
    var gender:Bool = false
    var age:Int = 0
    
    var exists: Bool = false;
    
    init(userId:String, phone:String, pw:String) {
        self.id = userId.makeNode();
        self.phone = phone;
        self.pw = pw;
        self.name = phone;
    }
    
    required init(node: Node, in context: Context) throws {
        id = try node.extract("id");
        name = try node.extract("name");
        phone = try node.extract("phone");
        pw = try node.extract("pw");
        gender = try node.extract("gender");
        age = try node.extract("age");
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "phone": phone,
            "pw": pw,
            "gender": gender,
            "age": age
            ])
    }
    
}

extension User123: Preparation {
    static func prepare(_ database: Database) throws {
        
        //建立表？
        try database.create("Users123") { users in
            users.id()
            users.string("name")
            users.string("phone")
            users.string("pw")
            users.bool("gender")
            users.int("age")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("Users123")
    }
}
