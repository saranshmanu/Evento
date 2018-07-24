//
//  QRViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QRViewController.dismissKeyboard)))
        event_id.layer.cornerRadius = event_id.frame.height/2
        event_id.attributedPlaceholder = NSAttributedString(string: event_id.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        event_id.backgroundColor = UIColor.clear
        event_id.layer.borderWidth = 2
        event_id.layer.borderColor = UIColor.white.cgColor
    }
    
    var eventIsLoading = false
    
    func dismissKeyboard() {
        event_id.resignFirstResponder()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        dismissKeyboard()
        if event_id.text! == ""{
            let alert = UIAlertController(title: "Field Empty!", message: "Enter the event ID", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let EVENT_ID = event_id.text!
            constants.event_id = EVENT_ID
            self.loader.isHidden = false
            self.loader.alpha = 1.0
            self.eventIsLoading = true
            networkEngine.getSession {success in
                if success == true{
                    self.loader.isHidden = true
                    self.loader.alpha = 0.0
                    self.eventIsLoading = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "homeTabBar")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.loader.isHidden = true
                    self.loader.alpha = 0.0
                    self.eventIsLoading = false
                    let alert = UIAlertController(title: "No such event found", message: "Try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.reader.startScanning()
                }
                
            }
        }
    }
    
    @IBOutlet weak var previewView: UIView!
    override func viewDidAppear(_ animated: Bool) {
        scanInPreviewAction(Any)
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController?
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            case -11814:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            default:
                alert = nil
            }
            guard let vc = alert else { return false }
            present(vc, animated: true, completion: nil)
            return false
        }
    }
    
    @IBAction func scanInModalAction(_ sender: AnyObject) {
        guard checkScanPermissions() else { return }
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var loader: UIView!
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if eventIsLoading == true {
            scrollView.isScrollEnabled = false
       }
    }
    @IBOutlet weak var event_id: UITextField!
    
    @IBAction func scanInPreviewAction(_ sender: Any) {
        guard checkScanPermissions(), !reader.isRunning else { return }
        reader.previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(reader.previewLayer)
        reader.startScanning()
        reader.didFindCode = { result in
            let EVENT_ID = result.value as String
            constants.event_id = EVENT_ID
            self.loader.isHidden = false
            self.loader.alpha = 1.0
            self.eventIsLoading = true
            networkEngine.getSession {success in
                if success == true{
                    self.loader.isHidden = true
                    self.loader.alpha = 0.0
                    self.eventIsLoading = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "homeTabBar")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.loader.isHidden = true
                    self.loader.alpha = 0.0
                    self.eventIsLoading = false
                    let alert = UIAlertController(title: "No such event found", message: "Try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.reader.startScanning()
                }
                
            }
//            self.loader.isHidden = false
//            self.loader.alpha = 1.0
//            self.eventIsLoading = true
//            networkEngine.getSession {
//                self.loader.isHidden = true
//                self.loader.alpha = 0.0
//                self.eventIsLoading = false
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "homeTabBar")
//                self.present(controller, animated: true, completion: nil)
//            }
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }

}
