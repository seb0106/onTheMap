//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

struct UdacityResponse: Decodable{
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
