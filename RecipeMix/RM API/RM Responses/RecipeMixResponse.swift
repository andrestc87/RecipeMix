//
//  RecipeMixResponse.swift
//  RecipeMix
//
//  Created by andres tello campos on 9/19/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import Foundation

struct RecipeMixResponse: Codable {
    let status: String
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case message = "message"
    }
}

extension RecipeMixResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
