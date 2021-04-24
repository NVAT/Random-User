//
//  LocalDataViewModel.swift
//  Brainstorm


import Foundation


class LocalDataViewModel {
    
    private let shared = SaveUserModel()
    static let shared = LocalDataViewModel()
    
    func readValues(saved param:inout [Results], page:Int = 0) {
        shared.readValues(saved: &param, page: page)
    }
    
    func insertValues(param:Results) {
        shared.insertValues(param: param)
    }
    
    func deleteValues(userId:Int){
        shared.deleteValues(userId: userId)
    }
    
    func isExist(uuid:String)->Bool{
        return shared.isExist(uuid: uuid)
    }
    
}
