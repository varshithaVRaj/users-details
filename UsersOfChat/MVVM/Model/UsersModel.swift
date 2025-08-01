//
//  ArtDetails.swift
//  ArtGallery
//
//  Created by Varshitha VRaj on 20/07/25.
//

import Foundation

struct Users: Decodable{

    var users: [ListOfUsers]?
    
}


struct ListOfUsers: Decodable{
    
    var firstName: String?
    var lastName: String?
    var image: String?

}



