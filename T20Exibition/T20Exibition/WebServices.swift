//
//  Webservices.swift
//  Movies
//
//  Created by Gurdeep on 21/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

class WebServices {
    
    func fetchDataFromPixabay(withQuery query: String,
                              success : @escaping (([ImageInfo]) -> Void),
                              failure : @escaping ((Error) -> Void)) {
        
        let URL = "https://pixabay.com/api/"
        
        let parameters = ["key" : "4609013-414f9bf36c6d94eeea32485fa",
                          "q" : query,
        ]
        
        NetworkController().GET(URL: URL,
                                parameters : parameters,
                                success : { (json : JSON) in
                                    
                                    print(json)
                                    
                                    let imagesArray = json["hits"].arrayValue
                                    
                                    var imageModels = [ImageInfo]()
                                    
                                    for image in imagesArray {
                                        
                                        imageModels.append(ImageInfo(withJSON: image))
                                    }
                                    
                                    success(imageModels)
                                    
        }, failure : { (error : Error) in
            
            failure(error)
        })
        
    }
    
}
