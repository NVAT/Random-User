//
//  DbManager.swift
//  Brainstorm
//

import Foundation

protocol DbManager {
    
    func insertValues(param:Results)
    func readValues(saved param:inout [Results], page:Int)
    func deleteValues(uuid:String)
    func isExist(uuid:String)->Bool
}
