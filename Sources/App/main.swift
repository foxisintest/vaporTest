import Vapor

let drop = Droplet()

//drop.get { req in
//    let lang = req.headers["Accept-Language"]?.string ?? "en"
//    return try drop.view.make("welcome", [
//    	"message": Node.string(drop.localization[lang, "welcome", "title"])
//    ])
//}
//
//drop.resource("posts", PostController())

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


drop.run()
