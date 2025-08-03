//
//  HomeAPIConfig.swift
//  Blu Transfer List
//
//  Created by Amir Hormozi on 8/2/25.
//

struct HomeAPIConfig: APIConfigProtocol {
    
    //MARK: Variable
    var url: String = "transfer-list/"
    var method: RequestMethod = .get
    var header: [String : String] = ["Content-Type": "application/json", "Accept": "*/*"]
    private var page: Int
    
    //MARK: LifeCycle
    init(page: Int) {
        url = url + String(page)
        self.page = page
    }
}
