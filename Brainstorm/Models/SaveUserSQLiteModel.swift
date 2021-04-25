//
//  SaveUserSQLiteModel.swift
//  Brainstorm

import Foundation
import SQLite3


struct SaveUserSQLiteModel:DbManager {
    
    private var db: OpaquePointer?
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    private let sqlLiteDB: SQLiteDB!
    private var isDebug = false
    
    init() {
        sqlLiteDB = SQLiteDB()
        db = sqlLiteDB.db
    }
    
    func insertValues(param:Results) {
        
        var errmsg = ""
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert data
        let queryString = "INSERT INTO USERS( " +
            "UUID, FIRSTNAME, LASTNAME, COUNTRY, STATE, CITY," +
            "STREET, STREETNUM, CELL, GENDER, LATITUDE, LONGITUDE, IMAGE)" +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        //preparing insert
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 1, param.login.uuid, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding uuid: \(errmsg)")
            }
            return
        }
        
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 2, param.name.first, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding firstname: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 3, param.name.last, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding lastname: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 4, param.location.country, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding country: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 5, param.location.state, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding state: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 6, param.location.city, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding city: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 7, param.location.street.name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
            }
            return
        }
        
        if let number = param.location.street.number {
            if sqlite3_bind_int(stmt, 8, Int32(number)) != SQLITE_OK{
                if isDebug {
                    errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding number: \(errmsg)")
                }
                return
            }
        }
        
        
        if sqlite3_bind_text(stmt, 9, param.phone, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding phone: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 10, param.gender, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding gender: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 11, param.location.coordinates.latitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding latitude: \(errmsg)")
            }
            return
        }
        
        if sqlite3_bind_text(stmt, 12, param.location.coordinates.longitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding longitude: \(errmsg)")
            }
            return
        }
        
        
        if sqlite3_bind_text(stmt, 13, param.picture.medium, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding medium: \(errmsg)")
            }
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting: \(errmsg)")
            }
            return
        }
        
        
    }
    
    func readValues(saved param:inout [Results], page:Int = 0){
        
        var errmsg = ""
        
        //this is our select query
        let queryString = "SELECT * FROM USERS " +
            "ORDER BY ID DESC " +
            "LIMIT 20 OFFSET ?"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing the query: \(errmsg)")
            }
            return
        }
        
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(page*20)) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding page: \(errmsg)")
            }
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = Int(sqlite3_column_int(stmt, 0))
            
            let name = Name(first: String(cString: sqlite3_column_text(stmt, 2)), last: String(cString: sqlite3_column_text(stmt, 3)))
            
            let coordinate = Coordinates(latitude: String(cString: sqlite3_column_text(stmt, 11)), longitude: String(cString: sqlite3_column_text(stmt, 12)))
            
            let street = Street(number: Int(sqlite3_column_int(stmt, 8)), name: String(cString: sqlite3_column_text(stmt, 7)))
            
            let location = Location(street: street, city: String(cString: sqlite3_column_text(stmt, 6)), state: String(cString: sqlite3_column_text(stmt, 5)), country: String(cString: sqlite3_column_text(stmt, 4)), coordinates: coordinate)
            
            let picture = Picture(thumbnail: nil, medium: String(cString: sqlite3_column_text(stmt, 13)), isSaved: true)
            
            let login = Login(uuid: String(cString: sqlite3_column_text(stmt, 1)))
            
            param += [Results(userId: id, gender: String(cString: sqlite3_column_text(stmt, 10)), name: name, location: location, phone: String(cString: sqlite3_column_text(stmt, 9)), cell: nil, picture: picture, login: login)]
            
        }
        
    }
    
    func deleteValues(uuid:String){
        
        var errmsg = ""
        let queryString = "DELETE FROM USERS WHERE UUID = ?"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing delete: \(errmsg)")
            }
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, uuid, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding userId: \(errmsg)")
            }
            return
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error delete: \(errmsg)")
            }
            return
        }
        
    }
    
    func isExist(uuid:String)->Bool{
        
        var errmsg = ""
        
        //this is our select query
        let queryString = "SELECT * FROM USERS WHERE UUID = ?"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            return false
        }
        
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, uuid, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            if isDebug {
                errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding uuid: \(errmsg)")
            }
            return false
        }
        
        var type = 0
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            type = Int(sqlite3_column_int(stmt, 0))
        }
        
        return type > 0
        
    }
    
}
