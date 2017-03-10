import Vapor
import HTTP
import FluentMongo

//demo code
/*
 let drop = Droplet()
 
 drop.get { req in
 return try drop.view.make("welcome", [
 "message": drop.localization[req.lang, "welcome", "title"]
 ])
 }
 
 drop.resource("posts", PostController())
 
 drop.run()
 */

//参考 https://segmentfault.com/a/1190000008421393?utm_source=tuicool&utm_medium=referral
final class UserMongoDB: Model {
    var exists: Bool = false
    
    var id: Node?
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

let mongo = try MongoDriver(database: "fox-db", user: "fox", password: "fox", host: "ds023052.mlab.com", port: 23052)
let db = Database(mongo)
let drop = Droplet()
drop.database = db
drop.preparations.append(UserMongoDB.self)

drop.post("login"){ req in
    guard let name = req.data["name"]?.string else{
        throw Abort.badRequest
    }
    var abc = UserMongoDB(name: name)
    try abc.save()
    return abc
}

drop.get("login"){req in
    var abc = UserMongoDB(name: "abcdefg")
    try abc.save()
    //    return try JSON(["memo":"mongoDB result id:\(abc.id!), name:\(abc.name)])
    return try JSON(["memo":"另可用postman测试post方法, Headers空，Body参数为name=xx"])
}

drop.run()

