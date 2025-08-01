//
//  DashboardViewModel.swift
//  UsersOfChat
//
//  Created by Varshitha VRaj on 01/08/25.
//
import Foundation


struct UsersDetailsRequest: APIRequest {
   
    let url: String
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
    
    init?() {
      
        self.url = BaseURL.listOfUsers
        self.method = .get
        self.headers = nil
        
     
        if self.method == .get {
            self.body = nil
        } else {
            self.body = Data()
        }
    }
}



class DashboardViewModel{
    
    private let service = NetworkService()
    public var listOfUsers: [ListOfUsers]?
    
    
    func fetchArtWorks(completion: @escaping(Bool) -> Void) {
    
            guard let request = UsersDetailsRequest() else {
                print("❌ Failed to create ArtworksRequest")
                return
            }
    
            service.request(request, responseType: Users.self) { result in
                switch result {
                case .success(let response):
                    if let data = response.users {
                        self.listOfUsers = data
                        print("API is view model is successful :\(self.listOfUsers?.count)")
                        completion(true)
                  
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    completion(false)
                }
            }
        }

    
}
