//
//  ProfileViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    @IBOutlet weak var statusPage: UIView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileHeading", for: indexPath)
            return cell
        } else if indexPath.row == 1{
            let imageQR = displayQRCode(code: qrcode)
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! BarcodeTableViewCell
            let scaleX = cell.barcodeImage.frame.size.width / imageQR.extent.size.width
            let scaleY = cell.barcodeImage.frame.size.height / imageQR.extent.size.height
            let transformedImage = imageQR.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
            cell.barcodeImage.image = UIImage(ciImage: transformedImage)
            cell.barcodeImage.contentMode = .scaleAspectFit
            cell.backView.layer.shadowColor = UIColor.black.cgColor
            cell.backView.layer.shadowOpacity = 1
            cell.backView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
            cell.backView.layer.shadowRadius = 9
            cell.nameTextLabel.text = name
            return cell
        } else if indexPath.row == 2{
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "wifiHeading", for: indexPath)
            return cell
        } else if indexPath.row == 3{
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "wifiCredentials", for: indexPath) as! WifiCredentialsTableViewCell
            cell.cardView.layer.shadowColor = UIColor.black.cgColor
            cell.cardView.layer.shadowOpacity = 1
            cell.cardView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
            cell.cardView.layer.shadowRadius = 9
            return cell
        } else if indexPath.row == 4{
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "scannedHeading", for: indexPath)
            return cell
        } else {
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "food", for: indexPath) as! ScannedFoodTableViewCell
            cell.cardView.layer.shadowColor = UIColor.black.cgColor
            cell.cardView.layer.shadowOpacity = 1
            cell.cardView.layer.shadowOffset = CGSize.init(width: 2, height: 2)
            cell.cardView.layer.shadowRadius = 9
            return cell
        }
    }
    

    @IBOutlet weak var profileTableView: UITableView!
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
            profileTableView.reloadData()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "authentication")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
//        displayQRCode(qr: code)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
