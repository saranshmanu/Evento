//
//  Utils.swift
//  Evento
//
//  Created by Saransh Mittal on 24/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import UIKit

class AlertView {
    public static func show(title: String, message: String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
