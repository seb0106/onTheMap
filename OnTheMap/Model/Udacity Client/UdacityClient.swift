//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

class UdacityClient{
    struct Auth{
        static var accountId = 1
    }
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        case login
        case studentsLocation
        case user
        var stringValue: String{
            switch self{
            case .login: return Endpoints.base + "/session"
                
            case .studentsLocation: return Endpoints.base + "/StudentLocation"
                
            case .user: return Endpoints.base + "/users/\(Auth.accountId)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    class func taskForGETRequest<ResponseType: Codable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        print(request.httpBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
         
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    class func getStudentsLocation(completion: @escaping (StudentLocation, Error?) -> Void){
        taskForGETRequest(url: Endpoints.studentsLocation.url, responseType: StudentLocation.self) { response, error in
            if let response = response{
                completion(response, nil)
            } else {
                let studentLocationEmpty = StudentLocation.init(results: [])
                completion(studentLocationEmpty, error)
            }
        }
        
    }
    
    class func postStudentLocation(studenLocationRequest: StudentLocationRequest,completion: @escaping(Bool, Error?)-> Void){
        let body = StudentLocationRequest(uniqueKey: studenLocationRequest.uniqueKey, firstName: studenLocationRequest.firstName, lastName: studenLocationRequest.lastName, mapString: studenLocationRequest.mapString, mediaURL: studenLocationRequest.mediaURL, latitude: studenLocationRequest.latitude, longitude: studenLocationRequest.longitude)
        print(body)
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(body)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        print(jsonData)
        print("lol")
        print(json)
        taskForPOSTRequest(url: Endpoints.studentsLocation.url, responseType: UserResponse.self, body: body){
            response, error in
            if let response = response{
                print(response)
                completion(true,nil)
            }
            else {
                print(error)
                completion(false,error)
            }
        }
    }
    
    class func login(email: String, password: String, completion: @escaping(Bool, Error?)->Void){
        let body = LoginRequest(udacity: UserInformationRequest(username: email, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body){
            response, error in
            if let response = response{
                completion(true, nil)
            }else{
                completion(false, error)
            }
            
        }
    }
}
