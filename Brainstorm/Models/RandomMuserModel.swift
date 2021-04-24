//
//  RandomMuserModel.swift
//  Brainstorm

import Foundation

struct Result:Decodable {
    var results:[Results]?
    //var info:Info?
}

//struct Info:Decodable {
//    var seed:String?
//    var results:Int?
//    var page:Int?
//    var version:String?
//}

struct Results:Decodable {
    var userId:Int?
    var gender:String?
    var name:Name
    var location:Location
    var phone:String?
    var cell:String?
    var picture:Picture
    var login:Login
}

struct Login:Decodable {
    var uuid:String?
}

struct Name:Decodable {
    var first:String?
    var last:String?
    
}

struct Location:Decodable {
    var street:Street
    var city:String?
    var state:String?
    var country:String?
    var coordinates:Coordinates
}

struct Street:Decodable {
    var number:Int?
    var name:String?
}

struct Coordinates:Decodable {
    var latitude:String?
    var longitude:String?
}

struct Picture:Decodable {
    var thumbnail:String?
    var medium:String?
    var isSaved:Bool?
}
