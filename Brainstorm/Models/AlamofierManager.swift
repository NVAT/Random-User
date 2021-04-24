//
//  AlamofierManager.swift
//  Brainstorm
//


import Foundation
import Alamofire


class AlamofierManager:Networkmanager {
    
    private var manager: SessionManager
    private var decoder: JSONDecoder
    private var url = "https://randomuser.me/api?seed=brainstorm&results=20&page={page}"    
    internal init() {
        self.manager = Alamofire.SessionManager.default
        self.decoder = JSONDecoder()
    }
    
    //MARK: - Make https request
    func request(page:Int, completionHandler: @escaping (Result?, Error?) -> ()) {
        guard let url = URL(string: url.replacingOccurrences(of: "{page}", with: String(page))) else {
            completionHandler(nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        self.manager.request(request).responseJSON { response in
            switch response.result {
            case .success( _):
                //print(json)
                if let resp = self.handleResp(data:response.data ?? Data()) {
                    completionHandler(resp, response.error)
                }
            case .failure(let error as NSError):
                completionHandler(nil, error)
            }
        }
    }
    
    func handleResp(data:Data) -> Result?  {
        
        do {
            return try self.decoder.decode(Result.self, from: data)
        }catch{
            return nil
        }
    }
    
}


