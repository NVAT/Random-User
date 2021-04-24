//
//  SaveUserModel.swift
//  Brainstorm

import Foundation
import SQLite3

struct SaveUserModel {
    
    private var db: OpaquePointer?
    private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    init() {
        
        // MARK: - the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UsersDatabase.sqlite")
        
        // MARK: - opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //                if sqlite3_exec(db, "DROP TABLE IF EXISTS USERS", nil, nil, nil) != SQLITE_OK {
        //                   let errmsg = String(cString: sqlite3_errmsg(db)!)
        //                   print("error drooped table: \(errmsg)")
        //                }
        
        // MARK: - creating table
        let sql = "CREATE TABLE IF NOT EXISTS USERS( " +
            "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "FIRSTNAME      CHAR(70), " +
            "LASTNAME       CHAR(70), " +
            "COUNTRY        CHAR(50), " +
            "STATE          CHAR(50), " +
            "CITY           CHAR(50), " +
            "STREET         CHAR(50), " +
            "STREETNUM      INTEGER, " +
            "CELL           CHAR(50), " +
            "GENDER         CHAR(10), " +
            "LATITUDE       CHAR(50), " +
            "LONGITUDE      CHAR(50), " +
            "UUID           CHAR(255), " +
            "IMAGE          TEXT)"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        
    }
    
    func insertValues(param:Results) {
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO USERS( " +
            "FIRSTNAME, LASTNAME, COUNTRY, STATE, CITY," +
            "STREET, STREETNUM, CELL, GENDER, LATITUDE, LONGITUDE, UUID, IMAGE)" +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            //return
        }
        
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, param.name.first, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 2, param.name.last, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 3, param.location.country, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 4, param.location.state, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 5, param.location.city, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 6, param.location.street.name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if let number = param.location.street.number {
            if sqlite3_bind_int(stmt, 7, Int32(number)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                //return
            }
        }
        
        
        if sqlite3_bind_text(stmt, 8, param.cell, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 9, param.gender, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 10, param.location.coordinates.latitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 11, param.location.coordinates.longitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 12, param.login.uuid, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        if sqlite3_bind_text(stmt, 13, param.picture.medium, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            //return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            //return
        }
        
        
    }
    
    func readValues(saved param:inout [Results], page:Int = 0){
        
        //this is our select query
        let queryString = "SELECT * FROM USERS " +
            "ORDER BY ID DESC " +
            "LIMIT 20 OFFSET ?"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(page*20)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let id = Int(sqlite3_column_int(stmt, 0))
            
            let name = Name(first: String(cString: sqlite3_column_text(stmt, 1)), last: String(cString: sqlite3_column_text(stmt, 2)))
            
            let coordinate = Coordinates(latitude: String(cString: sqlite3_column_text(stmt, 10)), longitude: String(cString: sqlite3_column_text(stmt, 11)))
            
            let street = Street(number: Int(sqlite3_column_int(stmt, 7)), name: String(cString: sqlite3_column_text(stmt, 6)))
            
            let location = Location(street: street, city: String(cString: sqlite3_column_text(stmt, 5)), state: String(cString: sqlite3_column_text(stmt, 4)), country: String(cString: sqlite3_column_text(stmt, 3)), coordinates: coordinate)
            
            let picture = Picture(thumbnail: nil, medium: String(cString: sqlite3_column_text(stmt, 13)), isSaved: true)
            
            let login = Login(uuid: String(cString: sqlite3_column_text(stmt, 12)))
            
            param += [Results(userId: id, gender: String(cString: sqlite3_column_text(stmt, 9)), name: name, location: location, phone: nil, cell: String(cString: sqlite3_column_text(stmt, 8)), picture: picture, login: login)]
            
        }
        
    }
    
    func deleteValues(userId:Int){
        
        let queryString = "DELETE FROM USERS WHERE ID = ?"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: \(errmsg)")
            return
        }
        
        //        //binding the parameters
        if sqlite3_bind_int(stmt, 1, Int32(userId)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error delete: \(errmsg)")
            return
        }
        
    }
    
    func isExist(uuid:String)->Bool{
        
        //this is our select query
        let queryString = "SELECT * FROM USERS WHERE UUID = ?"
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, uuid, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        var type = 0
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            type = Int(sqlite3_column_int(stmt, 0))
        }
        
        return type > 0
        
    }
    
}
