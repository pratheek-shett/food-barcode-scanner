//
//  BarcodeScanner.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/10/21.
//

import Foundation
import AVFoundation
import UIKit
import Firebase
import SwiftUI

class BarcodeScanner: UIViewController {
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
//    @Binding var result: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Your device is not applicable for video processing")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if (self.captureSession.canAddInput(videoInput)) {
                // Set the input device on the capture session
                self.captureSession.addInput(videoInput)
            }
        } catch {
            print("Your device can not give video input!")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (self.captureSession.canAddOutput(metadataOutput)) {
            // Set a AVCaptureMetadataOutput object as the output device to the capture session
            self.captureSession.addOutput(metadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            print("self.captureSession.canAddOutput() failed")
            return
        }
        
        // Initialize the video preview layer and add it as a subplayer to the viewPreview view's layer
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = self.view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        
        print("Running")
        // Start video capture
        self.captureSession.startRunning()
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
}

extension BarcodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        let delegate = HomeViewDelegate()
//        let controller = UIHostingController(rootView: HomeView())
        
        if let first = metadataObjects.first {
            guard let readableObject = first as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlaySystemSound(1000)
            found(code: stringValue)
        } else {
            print("Not able to read the code! Please try again or be keep your device on BarCode or Scanner Code!")
        }
    }
    
    func found(code: String) {
        print(code)
        var ref: DatabaseReference!
        ref = Database.database().reference()
//        ref.child("Message").setValue("hello from ios")
        
        ref.child("Message").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
            } else {
                print("No data available")
            }
        }
    }
    
}










