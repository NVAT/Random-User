//
//  SQLiteDB.swift
//  Brainstorm
//

import Foundation
import SQLite3

struct SQLiteDB {
    
    private(set) var db: OpaquePointer?
    
    init() {
        
        // MARK: - the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UsersDatabase.sqlite")
        
        // MARK: - opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            //print("error opening database")
        }
        
        // MARK: - creating table
        let sql = "CREATE TABLE IF NOT EXISTS USERS( " +
            "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "UUID           CHAR(255) NOT NULL UNIQUE, " +
            "FIRSTNAME      CHAR(70), " +
            "LASTNAME       CHAR(70), " +
            "COUNTRY        CHAR(50), " +
            "STATE          CHAR(50), " +
            "CITY           CHAR(50), " +
            "STREET         CHAR(50), " +
            "STREETNUM      INTEGER,  " +
            "CELL           CHAR(50), " +
            "GENDER         CHAR(10), " +
            "LATITUDE       CHAR(50), " +
            "LONGITUDE      CHAR(50), " +
            "IMAGE          TEXT)"
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            //            let errmsg = String(cString: sqlite3_errmsg(db)!)
            //            print("error creating table: \(errmsg)")
        }
        
    }
    
    private func dropTable() {
        
        if sqlite3_exec(db, "DROP TABLE IF EXISTS USERS", nil, nil, nil) != SQLITE_OK {
            //let errmsg = String(cString: sqlite3_errmsg(db)!)
            //print("error drooped table: \(errmsg)")
        }
    
    }
    
}
