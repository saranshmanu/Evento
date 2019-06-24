//
//  QRViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController {
    
    @IBAction func continueAction(_ sender: Any) {
        dismissKeyboard()
        if event_id.text! == "" {
            AlertView.show(title: "Field Empty!", message: "Enter the event ID", viewController: self)
        } else {
            forward()
        }
    }
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var event_id: UITextField!
    
    var eventIsLoading = false
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    func enableControls() {
        self.loader.isHidden = true
        self.loader.alpha = 0.0
        self.eventIsLoading = false
    }
    
    func disableControls() {
        self.loader.isHidden = false
        self.loader.alpha = 1.0
        self.eventIsLoading = true
    }
    
    func forward() {
        let eventCode = event_id.text!
        constants.event_id = eventCode
        self.disableControls()
        NetworkEngine.getSession { success in
            self.enableControls()
            if success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "homeTabBar")
                self.present(controller, animated: true, completion: nil)
            } else {
                AlertView.show(title: "No such event found", message: "Try again!", viewController: self)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        event_id.resignFirstResponder()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if eventIsLoading == true {
            scrollView.isScrollEnabled = false
        }
    }
    
    func initTextBoxView(textField: UITextField) {
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        textField.backgroundColor = UIColor.clear
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func initTapGestureForKeyboardDismiss() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QRViewController.dismissKeyboard)))
    }
    
    override func viewDidLoad() {
        initTapGestureForKeyboardDismiss()
        initTextBoxView(textField: event_id)
        initCameraSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func initCameraSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            AlertView.show(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", viewController: self)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            AlertView.show(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", viewController: self)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        event_id.text = code
        forward()
        captureSession.startRunning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
