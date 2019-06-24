//
//  ProfileViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var statusPage: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    var mealSchedule = [NSDictionary]()
    
    @IBAction func closeAction(_ sender: Any) {
        token = ""
        isLogged = false
        dismiss(animated: true, completion: nil)
    }
    
    func displayQRCode(code:String) -> CIImage {
        var qrcodeImage: CIImage!
        let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let colorFilter = CIFilter(name: "CIFalseColor")
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        colorFilter?.setValue(filter?.outputImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor.init(red: 1, green: 1, blue: 1, alpha: 1), forKey: "inputColor1")
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0, alpha: 1), forKey: "inputColor0") // Foreground or the barcode RED
        qrcodeImage = colorFilter?.outputImage
        return qrcodeImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLogged == true {
            statusPage.isHidden = true
            if session.count != 0{
                mealSchedule.removeAll()
                let a = session
                let b = a["event"] as! NSDictionary
                let c = b["eventSessions"] as! [NSDictionary]
                for i in c{
                    if i["sessionType"] as! String == "Meal" {
                        mealSchedule.append(i)
                    }
                }
                profileTableView.reloadData()
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "authentication")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    func getProfileCell(index: IndexPath, tableView: UITableView) -> BarcodeTableViewCell {
        let imageQR = displayQRCode(code: qrcode)
        let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: index) as! BarcodeTableViewCell
        let scaleX = cell.barcodeImage.frame.size.width / imageQR.extent.size.width
        let scaleY = cell.barcodeImage.frame.size.height / imageQR.extent.size.height
        let transformedImage = imageQR.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        cell.barcodeImage.image = UIImage(ciImage: transformedImage)
        cell.barcodeImage.contentMode = .scaleAspectFit
        cell.backView.layer.shadowColor = UIColor.black.cgColor
        cell.backView.layer.shadowOpacity = 1
        cell.backView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        cell.backView.layer.shadowRadius = 9
        cell.nameTextLabel.text = name
        return cell
    }
    
    func getWifiCredentialsCell(index: IndexPath, tableView: UITableView) -> WifiCredentialsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCredentials", for: index) as! WifiCredentialsTableViewCell
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        cell.cardView.layer.shadowOpacity = 1
        cell.cardView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        cell.cardView.layer.shadowRadius = 9
        cell.usernameTextLabel.text = wifiUser
        cell.passwordTextLabel.text = wifiPassword
        return cell
    }
    
    func getFoodCell(index: IndexPath, tableView: UITableView) -> ScannedFoodTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "food", for: index) as! ScannedFoodTableViewCell
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        cell.cardView.layer.shadowOpacity = 1
        cell.cardView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        cell.cardView.layer.shadowRadius = 9
        let flag = mealSchedule[index.row - 5]
        cell.nameLabel.text = flag["name"] as? String
        cell.dateLabel.text = flag["date"] as? String
        cell.timeLabel.text = flag["startTime"] as? String
        let participants = flag["participantsPresent"] as! [String]
        if participants.contains(userID) {
            cell.tick.isHidden = false
        } else {
            cell.tick.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + mealSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return tableView.dequeueReusableCell(withIdentifier: "profileHeading", for: indexPath)
        } else if indexPath.row == 1 {
            return getProfileCell(index: indexPath, tableView: tableView)
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "wifiHeading", for: indexPath)
            return cell
        } else if indexPath.row == 3 {
            return getWifiCredentialsCell(index: indexPath, tableView: tableView)
        } else if indexPath.row == 4 {
            return tableView.dequeueReusableCell(withIdentifier: "scannedHeading", for: indexPath)
        } else {
            return getFoodCell(index: indexPath, tableView: tableView)
        }
    }
}
