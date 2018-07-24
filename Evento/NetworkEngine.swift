//
//  NetworkEngine.swift
//  Evento
//
//  Created by Saransh Mittal on 24/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import Alamofire
import AlamofireImage

class networkEngine {
    
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
    
    public static func getSession(finished: @escaping () -> Void){
        let route = "/event/fetch/info"
        var url = constants.baseURL + route
        Alamofire.request(url, method: .post, parameters: ["event_id":constants.event_id]).responseJSON{
            response in if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as! NSDictionary{
                    if(a["success"] as! Bool == true){
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
                        for i in speakersImageURL{
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
                    }
                }
            }
            finished()
        }
    }
    public static func getProfile(finished: @escaping () -> Void){
        let route = "/user/verification"
        var url = constants.baseURL + route
        Alamofire.request(url, method: .post, parameters: ["event_id":constants.event_id], headers: ["x-access-token":token]).responseJSON{
            response in if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as! NSDictionary{
                    if a != nil {
                        qrcode = a["encrypted_id"] as! String
                    }
                }
            }
            finished()
        }
    }
    
    public static func getUserDetails(finished: @escaping () -> Void){
        let route = "/user/fetch/personal-info"
        var url = constants.baseURL + route
        Alamofire.request(url, method: .get, headers: ["x-access-token":token]).responseJSON{
            response in if response.result.isSuccess {
                if let a:NSDictionary = response.result.value! as! NSDictionary{
                    if a != nil {
                        if let b:NSDictionary = a["user"] as! NSDictionary{
                            if b != nil{
                                name = b["name"] as! String
                            }
                        }
                    }
                }
            }
            finished()
        }
    }
}
