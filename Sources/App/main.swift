import Vapor
import HTTP
import VaporMongo

//MARK:- 建数据库？User123
//User.swift 里的try database.create("Users123") 是建表？
let dbDrop = Droplet(preparations: [User123.self], providers: [VaporMongo.Provider.self]);

// /version?type='xxx'
dbDrop.get("version") { (req:Request) -> ResponseRepresentable in
    
    let type = req.query?["type"]?.string;
    
    var version = "none";
    if (type == "ios"){
        version = "2.0";
    }else if (type == "android"){
        version = "2.5";
    }
    
    let responseData = BaseResponse(code: 1001, msg: "success", data: ["version":version.makeNode()])
    
    return try Response(status: .ok, json: JSON(node: responseData));
}

dbDrop.get("/login"){ req in
    return "get login"
}

dbDrop.post("login"){req in
    // login
    let userController = UserController();
    dbDrop.post("login", handler: userController.login);
    return "post login!"
    
}

dbDrop.get("register"){req in
    // login
    let userController = UserController();
    dbDrop.post("register", handler: userController.register);
    return "register!"
}

let userController = UserController();
dbDrop.post("register", handler: userController.register);
dbDrop.post("login", handler: userController.login);

dbDrop.run()


//MARK:- 此Droplet不能运行在 dbDroplet前？？？？否则会出现 No preparations.
//只能运行一个Droplet??
let drop = Droplet()

drop.get { req in
    let lang = req.headers["Accept-Language"]?.string ?? "en"
    return try drop.view.make("welcome", [
    	"message": Node.string(drop.localization[lang, "welcome", "title"])
    ])
}


drop.resource("posts", PostController())

drop.get("/"){
    request in
    return "hello world"
}

drop.get("/name",":name"){ req in
    if let name = req.parameters["name"]?.string{
        return "hello \(name)!"
    }
    return "error parameters"
}

drop.get("/lll"){ req in
    return "lll"
}


drop.run()
