//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation


struct UserResponse: Decodable{
   let objectId: String?
   let createdAt: String?
}


extension UserResponse: LocalizedError{
    var errorDescription: String?{
        return objectId
    }
}
