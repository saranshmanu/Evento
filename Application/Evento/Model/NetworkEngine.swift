//
//  NetworkEngine.swift
//  Evento
//
//  Created by Saransh Mittal on 24/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import Alamofire
import AlamofireImage

class NetworkEngine {
    
    public static func fetchImageSpeakers(url:String, finished: @escaping () -> Void){
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                speakersImages[url] = image
            }
            finished()
        }
    }
    
    public static func fetchImageSponsors(url:String, finished: @escaping () -> Void){
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                sponsorsImages[url] = image
            }
            finished()
        }
    }
    
    public static func registerUserForEvent(completion: @escaping (Bool) -> ()) {
        let URL = constants.baseURL + "/user/participate"
        let params = [
            "event_id":constants.event_id
        ]
        let head = [
            "x-access-token":token
        ]
        Alamofire.request(URL, method: .post, parameters: params, headers: head).responseJSON { response in
            if response.result.isSuccess {
                if let b:NSDictionary = response.result.value! as? NSDictionary{
                    if b["success"] as! Bool == true {
                        // User successfully registered
                        NetworkEngine.getProfile {
                            NetworkEngine.getUserDetails {
                                completion(true)
                            }
                        }
                    } else if b["message"] as! String == "Already registered to this event" {
                        // User already registered
                        NetworkEngine.getProfile {
                            NetworkEngine.getUserDetails {
                                completion(true)
                            }
                        }
                    } else {
                        // Failed to register user for the event
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                // Cannot fetch results
                completion(false)
            }
        }
    }
    
    public static func loginUser(username: String, password: String, completion: @escaping (Bool) -> ()) {
        let route = "/authenticate/user/login"
        let url = constants.baseURL + route
        let params = [
            "email":username,
            "password":password
        ]
        Alamofire.request(url, method: .post, parameters: params).responseJSON{
            response in if response.result.isSuccess{
                let a = response.result.value! as! NSDictionary
                print(a)
                if a["success"] as! Bool == true{
                    token = a["token"] as! String
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    public static func registerUser(username: String, password: String, email: String, phoneNumber: String, name: String, completion: @escaping (Bool) -> ()) {
        let route = "/authenticate/user/register"
        let url = constants.baseURL + route
        let params = [
            "name":name,
            "email":email,
            "password":password,
            "username":username,
            "contact":phoneNumber
        ]
        Alamofire.request(url, method: .post, parameters: params).responseJSON{ response in
            if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as? NSDictionary{
                    if a["success"] as! Bool == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    public static func getSession(finished: @escaping (_ success:Bool) -> Void) {
        let route = "/event/fetch/info"
        let url = constants.baseURL + route
        let params = [
            "event_id":constants.event_id
        ]
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as? NSDictionary {
                    if a["success"] as! Bool == true {
                        session = a
                        let b = session["event"] as! NSDictionary
                        let c = b["speakers"] as! [NSDictionary]
                        var tempOne = c
                        speakersImageURL.removeAll()
                        for i in 0...tempOne.count - 1 {
                            let d = tempOne[i] as NSDictionary
                            speakersImageURL.append(String(describing: d["image_url"]!))
                        }
                        speakersImages.removeAll()
                        for i in speakersImageURL {
                            fetchImageSpeakers(url: i) {
                            }
                        }
                        let d = b["sponsors"] as! [NSDictionary]
                        var tempTwo = d
                        sponsorsImageURL.removeAll()
                        for i in 0...tempTwo.count - 1 {
                            let d = tempTwo[i] as NSDictionary
                            sponsorsImageURL.append(String(describing: d["img_url"]!))
                        }
                        sponsorsImages.removeAll()
                        for i in sponsorsImageURL{
                            fetchImageSponsors(url: i) {
                            }
                        }
                        finished(true)
                    }
                }
            }
            finished(false)
        }
    }
    public static func getProfile(finished: @escaping () -> Void){
        let route = "/user/verification"
        let url = constants.baseURL + route
        let params = [
            "event_id":constants.event_id
        ]
        let head = [
            "x-access-token":token
        ]
        Alamofire.request(url, method: .post, parameters: params, headers: head).responseJSON{ response in
            if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as? NSDictionary{
                    qrcode = a["encrypted_id"] as! String
                }
            }
            finished()
        }
    }
    
    public static func getUserDetails(finished: @escaping () -> Void){
        let route = "/user/fetch/personal-info"
        let url = constants.baseURL + route
        let head = [
            "x-access-token":token
        ]
        Alamofire.request(url, method: .get, headers: head).responseJSON { response in
            if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as? NSDictionary {
                    if let b:NSDictionary = a["user"] as? NSDictionary {
                        name = b["name"] as! String
                        userID = b["_id"] as! String
                        var check = 0
                        if let wifiDetails:[NSDictionary] = b["wifiCouponHistory"] as? [NSDictionary] {
                            for i in wifiDetails{
                                if i["event_id"] as! String == constants.event_id {
                                    wifiUser = i["coupon_id"] as! String
                                    wifiPassword = i["coupon_password"] as! String
                                    check = 1
                                    break
                                }
                            }
                        }
                        if check == 0 {
                            wifiUser = "Not available"
                            wifiPassword = "Not available"
                        }
                    }
                }
            }
            finished()
        }
    }
}
