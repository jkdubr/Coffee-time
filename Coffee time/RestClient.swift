//
//  RestClient.swift
//  GetString
//
//  Created by Jakub Dubrovsky on 10/09/15.
//  Copyright (c) 2015 Jakub Dubrovsky. All rights reserved.
//

import UIKit

private let __restClientSharedInstance = RestClient()

public class RestClient: NSObject {
    static let sharedInstance = __restClientSharedInstance
    
    let baseURL = NSURL(string: "https://api.parse.com/1/")!
    
    var baseRequest: NSMutableURLRequest   {
        
        let request = NSMutableURLRequest(URL: self.baseURL)
        request.setValue("00mMbLmX4sA7INHVvJSRveNj1deb2lU7B1nbzudD", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("1SHuSEvQwSZFqXjjEPd6MMivJKi8v3mNFFmhBHY6", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.setValue("EeOlFi3HByLaEjpPWNUOGRLBfLe8n1T2xP2xGcPd", forHTTPHeaderField: "X-Parse-Master-Key")
        
        return request
    }
    
    
    
    public func get(path: String, callback: (json: NSDictionary) -> Void ) {
        
        let request = self.baseRequest
        request.URL = request.URL?.URLByAppendingPathComponent(path)
        request.HTTPMethod = "GET"
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error)  -> Void in
            
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
            callback(json: jsonData)
        }
        
        task.resume()
    }
    
    public func post(path: String, object: NSDictionary ,callback: (json: NSDictionary) -> Void ) {

        let request = self.baseRequest
        request.URL = request.URL?.URLByAppendingPathComponent(path)
        request.HTTPMethod = "POST"
        
        let data = try! NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
        request.HTTPBody = data
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error)  -> Void in
            
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            
            callback(json: jsonData)
        }
        
        task.resume()
    }
    

    
}
