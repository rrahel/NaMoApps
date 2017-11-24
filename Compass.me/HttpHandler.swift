//
//  HttpHandler.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 24.11.17.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation

struct ResponseData {
    var result:Bool=false;
    var data:Any
}

var responseData: ResponseData = ResponseData(result: false, data: "");

class HttpHandler {
    
   class func httpPost(UrlString: String, RequestData: [String:Any]) -> ResponseData{
        var request = URLRequest(url: URL(string: UrlString )!)
        request.httpMethod = "POST"
        let json: [String:Any] = RequestData
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                responseData = ResponseData(result: false, data: "");
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                responseData = ResponseData(result: false, data: "");
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "")
            OperationQueue.main.addOperation {
                responseData = ResponseData(result: true, data: responseString);
            }
        }
        task.resume()
        return responseData;
    }
    
    
}
