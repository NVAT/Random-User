//
//  MainViewModel.swift
//  Brainstorm
//

import Foundation

class MainViewModel {
    
    private let manager:AlamofierManager!
    private var apiService : ApiService!
    
    internal var page:Int = 1 {
        didSet {
            self.callToGetUserData()
        }
    }
    
    var bindMainViewModelToController : ((_ data:[Results]?, _ error:Error?) -> ()) = {_,_  in }
    
    init() {
        self.manager = AlamofierManager()
        self.apiService = ApiService(manager: manager)
    }
    
    func callToGetUserData() {
        
        apiService.request(page: page) { (resp, error) in
            self.bindMainViewModelToController(resp?.results, error)
        }
    }
    
    var isInternetConnected:Bool {
        return apiService.isConnectedToInternet()
    }
    
}
