//
//  ApiService.swift
//  Brainstorm


import Foundation

protocol Networkmanager {
    func request(page:Int, completionHandler: @escaping (Result?, Error?) -> ())
    func handleResp(data:Data) -> Result?
}


class ApiService {

    private let manager: Networkmanager!
    internal var page = 1
    
    internal init(manager:Networkmanager) {
        self.manager = manager
    }
    
    //MARK: - Make https request
    func request(page:Int, completionHandler: @escaping (Result?, Error?) -> ()) {
        self.manager.request(page: page){ (result, error) in
            completionHandler(result, error)
        }
    }
    
}

