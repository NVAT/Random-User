//
//  ApiService.swift
//  Brainstorm


import Foundation

protocol NetworkManager {
    func request(page:Int, completionHandler: @escaping (Result?, Error?) -> ())
    func handleResp(data:Data) -> Result?
    func isConnectedToInternet() ->Bool
}


class ApiService {
    
    private let manager: NetworkManager!
    
    init(manager:NetworkManager) {
        self.manager = manager
    }
    
    //MARK: - Make https request
    func request(page:Int, completionHandler: @escaping (Result?, Error?) -> ()) {
        self.manager.request(page: page){ (result, error) in
            completionHandler(result, error)
        }
        
    }
    
    func isConnectedToInternet() ->Bool {
        self.manager.isConnectedToInternet()
    }
    
}

