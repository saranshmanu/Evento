//
//  ProfileViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var code = "String(describing: address)"
    
    func displayQRCodeImage() {
        let scaleX = barcodeImage.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = barcodeImage.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        barcodeImage.image = UIImage(ciImage: transformedImage)
        barcodeImage.contentMode = .scaleAspectFit
    }
    
    @IBOutlet weak var barcodeImage: UIImageView!
    var qrcodeImage: CIImage!
    func displayQRCode(qr:String) {
        var code = qr
        if self.qrcodeImage == nil {
            if code == "" {
                return
            }
            let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let colorFilter = CIFilter(name: "CIFalseColor")
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            colorFilter?.setValue(filter?.outputImage, forKey: "inputImage")
            colorFilter?.setValue(CIColor.init(red: 0, green: 0, blue: 0, alpha: 0), forKey: "inputColor1")
            colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1, alpha: 0.8), forKey: "inputColor0") // Foreground or the barcode RED
            self.qrcodeImage = colorFilter?.outputImage
            self.displayQRCodeImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayQRCode(qr: code)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
