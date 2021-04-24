//
//  MainViewModel.swift
//  Brainstorm
//
//  Created by Lsoft on 23.04.21.
//

import Foundation

class MainViewModel {
    
    private let manager:AlamofierManager!
    private var apiService : ApiService!
    
    private(set) var data : [Results]! {
        didSet {
            self.bindMainViewModelToController()
        }
    }
    internal var page:Int = 1 {
        didSet {
            self.callToGetUserData()
        }
    }
    
    var bindMainViewModelToController : (() -> ()) = {}
    
    init() {
        self.manager = AlamofierManager()
        self.apiService = ApiService(manager: manager)
    }
    
    func callToGetUserData() {
        
        apiService.request(page: page) { (resp, error) in
            if let result = resp?.results {
                self.data = result
            }
        }
    }
    
}
