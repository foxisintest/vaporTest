//
//  UserController.swift
//  NetworkTest
//
//  Created by aboojan on 2016/10/4.
//
//

import Vapor
import HTTP
import Fluent
import Foundation

final class UserController{

    func login(_ request:Request) throws -> ResponseRepresentable {
        
        let account = request.data["account"]?.string;
        let password = request.data["pw"]?.string;
        
        // fail
        guard (account != nil) && (password != nil) else {
            
            let failResponse = BaseResponse(code: 1000, msg: "缺少参数", data: nil);
            
            return try Response(status: .badRequest, json: JSON(node: failResponse));
        }
        
//        AJLog().debug("api:/login \n \(account) -- \(password)");
        
        let currentUser = try User.query().filter("phone", account!).first();
        if currentUser?.pw == password {
            
            // login success
            let responseData = try BaseResponse(code: 1001, msg: "success", data: currentUser?.makeNode());
            
            return try Response(status: .ok, json: JSON(node: responseData));
        }
        
        // login fail
        let failResponse = BaseResponse(code: 1000, msg: "账号或密码错误", data: nil);
        return try Response(status: .badRequest, json: JSON(node: failResponse));
        
    }
    
    func register(_ request:Request) throws -> ResponseRepresentable {
        
        let name = request.data["name"]?.string;
        let phone = request.data["phone"]?.string;
        let pw = request.data["pw"]?.string;
        let gender = request.data["gender"]?.bool;
        let age = request.data["age"]?.int;
        
        // 校验
        guard (name != nil) && (phone != nil) && (pw != nil) else {
            
            let failResponse = BaseResponse(code: 1000, msg: "缺少参数", data: nil);
            
            return try Response(status: .badRequest, json: JSON(node: failResponse));
        }
        
        // save
        let userId = UUID().uuidString;
        var user = User(userId: userId, phone: phone!, pw: pw!);
        user.name = name;
        user.gender = gender!;
        user.age = age!;
        
        try user.save();
        
        return try Response(status: .ok, json: JSON(node: ["userId": userId].makeNode()));
    }
    
}
