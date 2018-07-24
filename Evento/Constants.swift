//
//  Constants.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

var session = NSDictionary()
var speakersImages = [String:UIImage]()
var speakersImageURL = [String]()
var sponsorsImages = [String:UIImage]()
var sponsorsImageURL = [String]()
var isLogged:Bool = false
var token = ""
var qrcode = ""
var name = ""

class constants {
    public static let baseURL = "https://ieee-evento.herokuapp.com"
    public static let event_id = "ieee_techloop_congress"
}
