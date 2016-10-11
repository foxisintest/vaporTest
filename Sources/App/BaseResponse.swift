//
//  BaseResponse.swift
//  NetworkTest
//
//  Created by Aboo on 2016/9/29.
//
//

import Vapor
import Fluent

class BaseResponse:Model{
    
    var id: Node?
    var code: Int = 0
    var msg: String?
    var data: Node?
    
    init(code:Int, msg:String, data:Node?) {
        self.id = "0".makeNode();
        self.code = code;
        self.msg = msg;
        self.data = data;
    }
    
    required init(node: Node, in context: Context) throws {
        id = try node.extract("id");
        code = try node.extract("code");
        msg = try node.extract("msg");
        data = try node.extract("data");
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "code": code,
            "msg": msg,
            "data": data
            ]);
    }
}

extension BaseResponse: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}
