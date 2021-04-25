//
//  LocalDataViewModel.swift
//  Brainstorm


import Foundation

class LocalDataViewModel {
    
    static let shared = LocalDataViewModel()
    private let localService:SaveUserSQLiteModel!
    
    init() {
        localService = SaveUserSQLiteModel()
    }
    
    func insertValues(param:Results) {
        self.localService.insertValues(param: param)
    }
    
    func readValues(saved param:inout [Results], page:Int = 0) {
        self.localService.readValues(saved: &param, page: page)
    }
    
    func deleteValues(uuid:String) {
        self.localService.deleteValues(uuid: uuid)
    }
    
    func isExist(uuid:String)->Bool {
        return self.localService.isExist(uuid: uuid)
    }
    
    
    
    
}

